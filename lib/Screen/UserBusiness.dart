import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photoshare/Common/Constants.dart' as cnst;

class UserBusiness extends StatefulWidget {
  @override
  _UserBusinessState createState() => _UserBusinessState();
}

class _UserBusinessState extends State<UserBusiness> {
  TextEditingController txtCmpName = new TextEditingController();
  TextEditingController txtEmail = new TextEditingController();
  TextEditingController txtMobileNo = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    double ScreenHeight = MediaQuery.of(context).size.height;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: cnst.app_primary_material_color[900],
    ));

    /*return Scaffold(

      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Container(
                height: ScreenHeight * 0.3,
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                child: Image.asset("assets/image_01.png"),
              ),
              Positioned(
                top: ScreenHeight * 0.24,
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height,
                  // color: Colors.red,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Card(
                        elevation: 3,
                        child: Container(
                          //height: 200,
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: ScreenHeight * 0.17),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Denish Ubhal",style: TextStyle(fontSize: 17,letterSpacing: 0.4),),
                                    Padding(padding: EdgeInsets.only(top: 5)),
                                    Text("Email",style: TextStyle(fontSize: 15),),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 8)),
                      Card(
                        elevation: 3,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text("Business Information"),
                              ),
                              Divider(color: Colors.grey,),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              Container(
                                height: 50,
                                child: TextFormField(
                                  decoration: new InputDecoration(
                                    labelText: "Enter Email",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.circular(0.0),
                                      borderSide: new BorderSide(
                                      ),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  validator: (val) {
                                    if(val.length==0) {
                                      return "Email cannot be empty";
                                    }else{
                                      return null;
                                    }
                                  },
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
                                    labelText: "Enter Email",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.circular(0.0),
                                      borderSide: new BorderSide(
                                      ),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  validator: (val) {
                                    if(val.length==0) {
                                      return "Email cannot be empty";
                                    }else{
                                      return null;
                                    }
                                  },
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
                                    labelText: "Enter Email",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.circular(0.0),
                                      borderSide: new BorderSide(
                                      ),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  validator: (val) {
                                    if(val.length==0) {
                                      return "Email cannot be empty";
                                    }else{
                                      return null;
                                    }
                                  },
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
                                    labelText: "Enter Email",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.circular(0.0),
                                      borderSide: new BorderSide(
                                      ),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  validator: (val) {
                                    if(val.length==0) {
                                      return "Email cannot be empty";
                                    }else{
                                      return null;
                                    }
                                  },
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
                                    labelText: "Enter Email",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.circular(0.0),
                                      borderSide: new BorderSide(
                                      ),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  validator: (val) {
                                    if(val.length==0) {
                                      return "Email cannot be empty";
                                    }else{
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  style: new TextStyle(
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ),


                            ],
                          ),
                        ),
                      ),



                    ],
                  ),
                ),
              ),
              Positioned(
                top: ScreenHeight * 0.23,
                left: ScreenHeight * 0.03,
                child: Card(
                  elevation: 2,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        height: 80,
                        width: 80,
                        child: Image.asset(
                          "assets/logo.png",
                          height: 100,
                          width: 100,
                          fit: BoxFit.contain,
                        ),
                      )),
                ),
              )

            ],
          ),
        ),
      ),
    );*/

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
                            controller: txtMobileNo,
                            decoration: new InputDecoration(
                              labelText: "Enter MobileNo",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(0.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                            keyboardType: TextInputType.number,
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
