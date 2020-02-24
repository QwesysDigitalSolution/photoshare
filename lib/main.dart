import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:http/http.dart' as http;
import 'package:photoshare/Screen/Dashboard.dart';
import 'package:photoshare/Screen/Login.dart';
import 'package:photoshare/Screen/PreviewImage.dart';
import 'package:photoshare/Screen/Splash.dart';
import 'package:photoshare/Screen/UpdateBusinessProfile.dart';
import 'package:photoshare/Screen/UserBusiness.dart';
import 'package:photoshare/common/Constants.dart' as cnst;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print("onMessage");
      print(message);
    }, onResume: (Map<String, dynamic> message) {
      print("onResume");
      print(message);
    }, onLaunch: (Map<String, dynamic> message) {
      print("onLaunch");
      print(message);
    });

    //For Ios Notification
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Setting reqistered : $settings");
    });
  }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: "Photoshare",
      debugShowCheckedModeBanner: false,
      home: Splash(),
      routes: {
        '/Login': (context) => Login(),
        '/UserBusiness': (context) => UserBusiness(),
        '/Dashboard': (context) => Dashboard(),
        '/UpdateBusinessProfile': (context) => UpdateBusinessProfile(),
        //'/PreviewImage': (context) => PreviewImage(),
      },
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
          body1: GoogleFonts.oswald(textStyle: textTheme.body1),
        ),
        primaryColor: cnst.app_primary_material_color,
        primarySwatch: cnst.app_primary_material_color,
      ),
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

/*class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool isLogged = false;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  static final FacebookLogin facebookSignIn = new FacebookLogin();
  String _message = 'Log in/out by pressing the buttons below.';

  Future<Null> _loginwithFB() async {
    try {
      final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final FacebookAccessToken accessToken = result.accessToken;

          var graphResponse = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${accessToken.token}');

          var profile = json.decode(graphResponse.body);
          print(profile.toString());

          _showMessage('''
         Logged in!
         Name: ${profile['name']}
         Image: ${profile['picture']['data']['url']}
         email: ${profile['email']}
         ''');
          _logout();
          break;
        case FacebookLoginStatus.cancelledByUser:
          _showMessage('Login cancelled by the user.');
          _logout();
          break;
        case FacebookLoginStatus.error:
          // _changeBlackVisible();
          _showMessage('Something went wrong with the login process.\n'
              'Here\'s the error Facebook gave us: ${result.errorMessage}');
          _logout();
      }
    } catch (e) {
      print("Error in facebook sign in: $e");
      _logout();
    }
  }

  void _showMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  Future<FirebaseUser> _signin(BuildContext context) async {
    *//*Scaffold.of(context).showSnackBar(new SnackBar(
      content: Text("Sign In"),
    ));*//*

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

    *//*Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => ProfileScreen(detailsUser: details),
        ));*//*

    _showMessage('''
         Logged in!
         Name: ${userDetails.displayName}
         Image: ${userDetails.photoUrl}
         email: ${userDetails.email}
         ''');

    print("${userDetails.email}");

    return userDetails;
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  _logout() async {
    await facebookSignIn.logOut();
    await _googleSignIn.signOut();
    print("Logged out");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              margin: EdgeInsets.only(top: 20),
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(8.0)),
                color: Colors.red,
                minWidth: MediaQuery.of(context).size.width,
                onPressed: () {
                  _signin(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        //shape: BoxShape.circle,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.transparent,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.transparent,
                          size: 20,
                        ),
                      ),
                    ),
                    Text(
                      "Sign In With Google",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        //shape: BoxShape.circle,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.red,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            FacebookSignInButton(
              onPressed: _loginwithFB,
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              margin: EdgeInsets.only(top: 20),
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(8.0)),
                color: Colors.red,
                minWidth: MediaQuery.of(context).size.width,
                onPressed: () {
                  _logout();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        //shape: BoxShape.circle,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.transparent,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.transparent,
                          size: 20,
                        ),
                      ),
                    ),
                    Text(
                      "Logout",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        //shape: BoxShape.circle,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.red,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: <Widget>[Text(_message)],
            )
          ],
        ),
      ),
    );
  }
}*/

class UserDetails {
  final String provideDetails;
  final String userName;
  final String photoUrl;
  final String userEmail;
  final List<ProviderDetails> providerData;

  UserDetails(this.provideDetails, this.userName, this.photoUrl, this.userEmail,
      this.providerData);
}

class ProviderDetails {
  final String providerDetails;

  ProviderDetails(this.providerDetails);
}
