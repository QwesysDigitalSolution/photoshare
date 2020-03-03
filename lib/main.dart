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
