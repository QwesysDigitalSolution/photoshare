import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:photoshare/Common/Constants.dart' as cnst;
import 'package:http/http.dart' as http;
import 'package:photoshare/main.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  Future<Null> _loginwithFB() async {
    try {
      final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final FacebookAccessToken accessToken = result.accessToken;

          var graphResponse = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,birthday,last_name,email,picture.height(200)&access_token=${accessToken.token}');

          var profile = json.decode(graphResponse.body);
          print(profile.toString());

          Fluttertoast.showToast(
              msg: "Name : ${profile['name']}\n"
                  "Image: ${profile['picture']['data']['url']}\n"
                  "email: ${profile['email']}\n",
              fontSize: 13,
              backgroundColor: Colors.white,
              gravity: ToastGravity.TOP,
              textColor: Colors.black);
          _logout();
          break;
        case FacebookLoginStatus.cancelledByUser:
          Fluttertoast.showToast(
              msg: "Login cancelled by the user.",
              fontSize: 13,
              backgroundColor: Colors.redAccent,
              gravity: ToastGravity.TOP,
              textColor: Colors.white);
          _logout();
          break;
        case FacebookLoginStatus.error:
          Fluttertoast.showToast(
              msg: "Something went wrong with the login process.\n"
                  "Here\'s the error Facebook gave us: ${result.errorMessage}",
              fontSize: 13,
              backgroundColor: Colors.redAccent,
              gravity: ToastGravity.TOP,
              textColor: Colors.white);
          _logout();
      }
    } catch (e) {
      print("Error in facebook sign in: $e");
      _logout();
    }


  }

  Future<FirebaseUser> _signin(BuildContext context) async {
    /*Scaffold.of(context).showSnackBar(new SnackBar(
      content: Text("Sign In"),
    ));*/

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential1 = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    FirebaseUser userDetails =
        await _firebaseAuth.signInWithCredential(credential1);
    ProviderDetails providerInfo = new ProviderDetails(userDetails.providerId);



    List<ProviderDetails> providerData = new List<ProviderDetails>();
    providerData.add(providerInfo);
    UserDetails details = new UserDetails(
        userDetails.providerId,
        userDetails.displayName,
        userDetails.photoUrl,
        userDetails.email,
        providerData);

    /*Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => ProfileScreen(detailsUser: details),
        ));*/
    if (googleUser != null) {
      await _logout();
      Navigator.pushReplacementNamed(context, "/UserBusiness");
    }

    /*_showMessage('''
         Logged in!
         Name: ${userDetails.displayName}
         Image: ${userDetails.photoUrl}
         email: ${userDetails.email}
         ''');*/

    Fluttertoast.showToast(
        msg: "Name: ${userDetails.displayName}\n"
            "Image: ${userDetails.photoUrl}\n"
            "email: ${userDetails.email}\n",
        fontSize: 13,
        backgroundColor: Colors.white,
        gravity: ToastGravity.TOP,
        textColor: Colors.black);
    print("${userDetails.email}");
    print(userDetails.phoneNumber);
    return userDetails;
  }

  _logout() async {
    await facebookSignIn.logOut();
    await _googleSignIn.signOut();
    print("Logged out");
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
                                        _signin(context);
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
                              "Poword by : ",
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
