import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photoshare/Common/Constants.dart' as cnst;
import 'package:photoshare/common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBusiness extends StatefulWidget {
  @override
  _UserBusinessState createState() => _UserBusinessState();
}

class _UserBusinessState extends State<UserBusiness> {
  TextEditingController txtCmpName = new TextEditingController();
  TextEditingController txtEmail = new TextEditingController();
  TextEditingController txtMobileNo = new TextEditingController();
  File _memberImage;

  ProgressDialog pr;
  String MemberId = "", CmpImage = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocalData();
  }

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      MemberId = prefs.getString(cnst.session.Member_Id);
      CmpImage = prefs.getString(cnst.session.Image);
    });
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

  void _profileImagePopup(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.camera_alt),
                    title: new Text('Camera'),
                    onTap: () async {
                      var image = await ImagePicker.pickImage(
                        source: ImageSource.camera,
                      );
                      if (image != null) {
                        setState(() {
                          _memberImage = image;
                          print(_memberImage);
                        });
                        await showPrDialog();
                        sendUserProfileImg();
                      }
                      Navigator.pop(context);
                    }),
                new ListTile(
                    leading: new Icon(Icons.photo),
                    title: new Text('Gallery'),
                    onTap: () async {
                      var image = await ImagePicker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (image != null) {
                        setState(() {
                          _memberImage = image;
                        });
                        await showPrDialog();
                        sendUserProfileImg();
                      }
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
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

  sendUserProfileImg() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await showPrDialog();
        pr.show();
        String filename = "";
        File compressedFile;

        if (_memberImage != null) {
          var file = _memberImage.path.split('/');
          filename = "user.png";

          if (file != null && file.length > 0)
            filename = file[file.length - 1].toString();

          ImageProperties properties =
              await FlutterNativeImage.getImageProperties(_memberImage.path);
          compressedFile = await FlutterNativeImage.compressImage(
              _memberImage.path,
              quality: 100,
              targetWidth: 600,
              targetHeight:
                  (properties.height * 600 / properties.width).round());
        }

        FormData formData = new FormData.fromMap({
          "UserId": MemberId,
          "Photo": _memberImage != null
              ? await MultipartFile.fromFile(compressedFile.path,
                  filename: filename.toString())
              : null
        });

        Services.PostServiceForSave("UpdateCompanyLogo.php", formData).then(
            (data) async {
          pr.hide();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (data.Data != "0" && data.Data != "") {
            await prefs.setString(cnst.session.Image, data.Data);
            Fluttertoast.showToast(
              msg: "Profile Updated Successfully.",
              fontSize: 18,
              backgroundColor: Colors.black,
              gravity: ToastGravity.CENTER,
              textColor: Colors.white,
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIos: 3,
            );
          } else {
            showMsg(data.Message);
            setState(() {
              _memberImage = null;
            });
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Try Again.");
          setState(() {
            _memberImage = null;
          });
        });
      }
    } on SocketException catch (_) {
      pr.isShowing() ? pr.hide() : Container();
      showMsg("No Internet Connection.");
    }
  }

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
        child: SingleChildScrollView(
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
                    GestureDetector(
                      onTap: () {
                        _profileImagePopup(context);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          //side: BorderSide(color: cnst.appcolor)),
                          side: BorderSide(
                              width: 0.10, color: Colors.transparent),
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 8, bottom: 0),
                              child: Container(
                                height: 90,
                                width: 90,
                                decoration: BoxDecoration(
                                  color: const Color(0xff7c94b6),
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(100)),
                                  border: new Border.all(
                                    color: cnst.app_primary_material_color,
                                    width: 2.0,
                                  ),
                                ),
                                child: ClipOval(
                                  child: _memberImage == null
                                      ? CmpImage == ""
                                          ? Image.asset(
                                              "assets/upload.png",
                                              height: 90,
                                              width: 90,
                                              fit: BoxFit.contain,
                                            )
                                          : FadeInImage.assetNetwork(
                                              placeholder: "assets/loading.gif",
                                              image: "${CmpImage}",
                                              height: 90,
                                              width: 90,
                                              fit: BoxFit.cover,
                                            )
                                      : Image.file(
                                          File(_memberImage.path),
                                          height: 90,
                                          width: 90,
                                          fit: BoxFit.fill,
                                        ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    "Upload Logo",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  Icon(
                                    Icons.edit,
                                    size: 12,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: ScreenHeight * 0.3),
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
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5.0)),
                          color: cnst.app_primary_material_color,
                          minWidth: MediaQuery.of(context).size.width,
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, "/Dashboard");
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
            ],
          ),
        ),
      ),
    );
  }
}
