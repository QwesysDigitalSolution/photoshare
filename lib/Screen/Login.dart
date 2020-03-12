import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:photoshare/Common/Constants.dart' as cnst;
import 'package:http/http.dart' as http;
import 'package:photoshare/common/Services.dart';
import 'package:photoshare/main.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  StreamSubscription iosSubscription;
  String fcmToken = "";

  ProgressDialog pr;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isIOS) {
      iosSubscription =
          _firebaseMessaging.onIosSettingsRegistered.listen((data) {
        print("FFFFFFFF" + data.toString());
        saveDeviceToken();
      });
      _firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
    } else {
      saveDeviceToken();
    }
  }

  saveDeviceToken() async {
    _firebaseMessaging.getToken().then((String token) {
      print("Original Token:$token");
      setState(() {
        fcmToken = token;
        //sendFCMTokan(token);
      });
      print("FCM Token : $fcmToken");
    });
  }

  Future<Null> _loginwithFB() async {
    try {
      final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          await showPrDialog();
          pr.show();
          final FacebookAccessToken accessToken = result.accessToken;

          var graphResponse = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,birthday,last_name,email,picture.height(200)&access_token=${accessToken.token}');

          var profile = json.decode(graphResponse.body);
          print(profile.toString());

          /*Fluttertoast.showToast(
              msg: "Name : ${profile['name']}\n"
                  "Image: ${profile['picture']['data']['url']}\n"
                  "email: ${profile['email']}\n",
              fontSize: 13,
              backgroundColor: Colors.white,
              gravity: ToastGravity.TOP,
              textColor: Colors.black);*/

          await pr.hide();
          await _logout();
          await sendUserDetails(profile['id'].toString(), profile['name'],
              profile['picture']['data']['url'], profile['email'], "FB");
          break;
        case FacebookLoginStatus.cancelledByUser:
          await pr.hide();
          Fluttertoast.showToast(
            msg: "Try Again",
            fontSize: 15,
            backgroundColor: Colors.black,
            gravity: ToastGravity.CENTER,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIos: 4,
          );
          //await pr.hide();
          _logout();
          break;
        case FacebookLoginStatus.error:
          await pr.hide();
          //await pr.hide();
          Fluttertoast.showToast(
            msg: "Try Again",
            fontSize: 15,
            backgroundColor: Colors.black,
            gravity: ToastGravity.CENTER,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIos: 4,
          );
          _logout();
      }
    } catch (e) {
      print("Error in facebook sign in: $e");
      await pr.hide();
      _logout();
    }
  }

  Future<FirebaseUser> _signin(BuildContext context) async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    await showPrDialog();
    pr.show();
    final AuthCredential credential1 = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    AuthResult userDetails =
        await _firebaseAuth.signInWithCredential(credential1);
    //ProviderDetails providerInfo = new ProviderDetails(userDetails.providerId);

    List<ProviderDetails> providerData = new List<ProviderDetails>();
    userDetails.user;
    print(userDetails.user);
    //providerData.add(userDetails.user);
    UserDetails details = new UserDetails(
        userDetails.user.providerId,
        userDetails.user.displayName,
        userDetails.user.photoUrl,
        userDetails.user.email,
        providerData);

    await pr.hide();
    if (googleUser != null) {
      Fluttertoast.showToast(
        msg: "Login Successfully",
        fontSize: 15,
        backgroundColor: Colors.black,
        gravity: ToastGravity.CENTER,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIos: 4,
      );
      await _logout();
      await sendUserDetails(
          userDetails.user.uid.toString(),
          userDetails.user.displayName.toString(),
          userDetails.user.photoUrl.toString(),
          userDetails.user.email.toString(),
          "Gmail");
    } else {
      Fluttertoast.showToast(
        msg: "Try Again",
        fontSize: 15,
        backgroundColor: Colors.black,
        gravity: ToastGravity.CENTER,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIos: 4,
      );
    }
    return userDetails.user;
  }

  _logout() async {
    //await pr.hide();
    await facebookSignIn.logOut();
    await _googleSignIn.signOut();
    print("Logged out");
  }

  showPrDialog() async {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
                cnst.app_primary_material_color),
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
  }

  showMsg(String msg, {String title = 'Madhusudan'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  sendUserDetails(String providerId, String name, String photourl, String email,
      String type) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await showPrDialog();
        pr.show();

        FormData formData = new FormData.fromMap({
          "Id": providerId,
          "Name": name,
          "Image": photourl,
          "Email": email,
          "Type": type,
          "FCMToken": fcmToken.toString(),
        });

        Services.PostServiceForSave("SendMemberInfo.php", formData).then(
            (data) async {
          pr.hide();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (data.Data.toString() != "0" && data.Data.toString() != "") {
            await prefs.setString(cnst.session.Member_Id, data.Data.toString());
            await prefs.setString(cnst.session.Name, name.toString());
            await prefs.setString(cnst.session.Email, email);
            await prefs.setString(cnst.session.UserImage, photourl);
            await prefs.setString(cnst.session.LoginStep, "Step1");
            Navigator.pushReplacementNamed(context, "/UserBusiness");
          } else {
            showMsg(data.Message);
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Try Again.");
        });
      }
    } on SocketException catch (_) {
      pr.isShowing() ? pr.hide() : Container();
      showMsg("No Internet Connection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: cnst.app_primary_material_color[900],
    ));

    double widt = MediaQuery.of(context).size.width;
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    /*ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);*/

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Image.asset("assets/image_01.png"),
              ),
              Expanded(
                child: Container(),
              ),
              Image.asset("assets/image_02.png")
            ],
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 0.0),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.asset(
                              "assets/logo.png",
                              width: 50,
                              height: 50,
                              fit: BoxFit.contain,
                            ),
                            Text("LOGO",
                                style: TextStyle(
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(46),
                                    letterSpacing: .6,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(
                          height: widt * 0.35,
                        ),
                        Container(
                          width: double.infinity,
                          //height: ScreenUtil.getInstance().setHeight(500),
                          height: widt * 0.62,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(0.0, 15.0),
                                    blurRadius: 15.0),
                                BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(0.0, -10.0),
                                    blurRadius: 10.0),
                              ]),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 16.0, right: 16.0, top: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Login",
                                      style: TextStyle(
                                          fontSize: ScreenUtil.getInstance()
                                              .setSp(45),
                                          letterSpacing: .6)),
                                  SizedBox(
                                    height:
                                        ScreenUtil.getInstance().setHeight(10),
                                  ),
                                  //Gmail Login
                                  Container(
                                    //width: MediaQuery.of(context).size.width / 1.5,
                                    margin: EdgeInsets.only(top: 20),
                                    height: 45,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(8.0)),
                                      color: Colors.red,
                                      minWidth:
                                          MediaQuery.of(context).size.width,
                                      onPressed: () {
                                        _signin(context)==null?pr.hide():null;
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/googlepl.png",
                                            height: 30,
                                            width: 30,
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10)),
                                          Text(
                                            "Continue with Google",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.w600),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        ScreenUtil.getInstance().setHeight(35),
                                  ),
                                  //Facebook Login
                                  Container(
                                    //width: MediaQuery.of(context).size.width / 1.5,
                                    margin: EdgeInsets.only(top: 0),
                                    height: 45,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(8.0)),
                                      color: Colors.blueAccent,
                                      minWidth:
                                          MediaQuery.of(context).size.width,
                                      onPressed: _loginwithFB,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/fb.png",
                                            height: 30,
                                            width: 30,
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10)),
                                          Text(
                                            "Continue with Facebook",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.w600),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        ScreenUtil.getInstance().setHeight(35),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        //color: Colors.black,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Power by : ",
                              style: TextStyle(),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Text("qwesys.com",
                                  style: TextStyle(
                                    color: Color(0xFF5d74e3),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
