import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photoshare/Common/Constants.dart' as cnst;
import 'package:photoshare/common/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> heartbeatAnimation;

  @override
  void initState() {
    /*controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    controller.forward().whenComplete(() {
      controller.reverse();
    });*/

    Timer(Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(cnst.session.Member_Id);
      String login_Step = prefs.getString(cnst.session.LoginStep);
      if (MemberId != null && MemberId != "" && login_Step=="Done") {
        Navigator.pushReplacementNamed(context, '/Dashboard');
      } else {
        if(login_Step=="Step1"){
          Navigator.pushReplacementNamed(context, "/UserBusiness");
        }else{
          Navigator.pushReplacementNamed(context, '/Login');
        }
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          //width: MediaQuery.of(context).size.width,
          height: 150,
          width: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/logo.png"),
            ],
          ),
        ),
      ),
    );
  }

  /*@override
  void dispose() {
    super.dispose();
    controller.dispose();
  }*/
}
