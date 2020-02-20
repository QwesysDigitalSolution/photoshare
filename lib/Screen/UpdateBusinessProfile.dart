import 'package:flutter/material.dart';
import 'package:photoshare/Common/Constants.dart' as cnst;

class UpdateBusinessProfile extends StatefulWidget {
  @override
  _UpdateBusinessProfileState createState() => _UpdateBusinessProfileState();
}

class _UpdateBusinessProfileState extends State<UpdateBusinessProfile> {

  TextEditingController txtCmpName = new TextEditingController();
  TextEditingController txtEmail = new TextEditingController();
  TextEditingController txtMobileNo = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    double ScreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              height: ScreenHeight * 0.35,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage("assets/image_01.png")),
                color: Colors.black,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xff7c94b6),
                      borderRadius:
                      new BorderRadius.all(new Radius.circular(100)),
                      border: new Border.all(
                        color: cnst.app_primary_material_color,
                        width: 2.0,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/logo.png",
                        height: 80,
                        width: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: ScreenHeight * 0.3),
                child: Container(
                  //height: ScreenHeight - (ScreenHeight * 0.3),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, bottom: 5),
                          child: Text(
                            "Business Information",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        Container(
                          height: 50,
                          child: TextFormField(
                            controller: txtCmpName,
                            decoration: new InputDecoration(
                              labelText: "Enter Company Name",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(0.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                            keyboardType: TextInputType.text,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                          height: 50,
                          child: TextFormField(
                            controller: txtEmail,
                            decoration: new InputDecoration(
                              labelText: "Enter Email",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(0.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                            keyboardType: TextInputType.emailAddress,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                          height: 50,
                          child: TextFormField(
                            decoration: new InputDecoration(
                              labelText: "Business Category",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(0.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                            keyboardType: TextInputType.emailAddress,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                          height: 50,
                          child: TextFormField(
                            decoration: new InputDecoration(
                              labelText: "State",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(0.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                            keyboardType: TextInputType.emailAddress,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                          height: 50,
                          child: TextFormField(
                            decoration: new InputDecoration(
                              labelText: "City",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(0.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                            keyboardType: TextInputType.emailAddress,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        Container(
                          //width: MediaQuery.of(context).size.width / 1.5,
                          margin: EdgeInsets.only(top: 0),
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(8))),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0)),
                            color: cnst.app_primary_material_color,
                            minWidth: MediaQuery.of(context).size.width,
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, "/Dashboard");
                            },
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Poppins"),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
