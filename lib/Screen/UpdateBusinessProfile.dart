import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photoshare/Common/Constants.dart' as cnst;
import 'package:photoshare/common/ClassList.dart';
import 'package:photoshare/common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateBusinessProfile extends StatefulWidget {
  @override
  _UpdateBusinessProfileState createState() => _UpdateBusinessProfileState();
}

class _UpdateBusinessProfileState extends State<UpdateBusinessProfile> {
  TextEditingController txtCmpName = new TextEditingController();
  TextEditingController txtEmail = new TextEditingController();
  TextEditingController txtMobileNo = new TextEditingController();
  File _memberImage;

  ProgressDialog pr;
  String MemberId = "", CmpImage = "";

  //get category
  List<categoryClass> _categoryList = [];
  categoryClass _categoryClass;

  List<stateClass> _stateList = [];
  stateClass _stateClass;

  List<cityClass> _cityList = [];
  cityClass _cityClass;

  bool stateLoading = false, cityLoading = false;
  String BusinessCategory = "Select Business Category";

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
      CmpImage = prefs.getString(cnst.session.Image).toString();
      BusinessCategory =
          prefs.getString(cnst.session.CompanyCatName).toString();
    });
    await getBusinessCategory();
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
                        //await showPrDialog();
                        sendUserProfileImg();
                      }
                      Navigator.pop(context);
                    }),
                new ListTile(
                    leading: new Icon(Icons.photo),
                    title: new Text('Gallery'),
                    onTap: () async {
                      var image1 = await ImagePicker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (image1 != null) {
                        setState(() {
                          _memberImage = image1;
                        });
                        //await showPrDialog();
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

  //get Business Category Item
  getBusinessCategory() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.getCategorys();
        await showPrDialog();
        pr.show();
        res.then((data) async {
          if (data != null && data.length > 0) {
            pr.hide();
            setState(() {
              _categoryList = data;
            });
          } else {
            setState(() {
              _categoryList.clear();
            });
            pr.hide();
          }
        }, onError: (e) {
          showMsg("Try Again");
          pr.hide();
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  //getState
  _getStates() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.getStates();
        setState(() {
          stateLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _stateList = data;
              stateLoading = false;
            });
          } else {
            setState(() {
              _stateList = data;
              stateLoading = false;
            });
          }
        }, onError: (e) {
          showMsg("$e");
          setState(() {
            stateLoading = false;
          });
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  //getCity
  _getCity(String id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.getCity(id);
        setState(() {
          _cityList.clear();
          _cityClass = null;
          cityLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _cityList = data;
              cityLoading = false;
            });
          } else {
            setState(() {
              _cityList = data;
              cityLoading = false;
            });
          }
        }, onError: (e) {
          showMsg("$e");
          setState(() {
            cityLoading = false;
          });
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return true;
    else
      return false;
  }

  bool validateMobile(String value) {
    Pattern pattern = r'^[6-9][0-9]{9}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return true;
    else
      return false;
  }

  //send Compnay Info
  sendCompanyInfo() async {
    try {
      String CatId = "", CatName = "";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await showPrDialog();
        pr.show();

        if (_categoryClass == null) {
          CatId = prefs.getString(cnst.session.CompanyCatId).toString();
          CatName = prefs.getString(cnst.session.CompanyCatName).toString();
        } else {
          CatId = _categoryClass.id;
          CatName = _categoryClass.name;
        }

        FormData formData = new FormData.fromMap({
          "UserId": MemberId,
          "CompanyName": txtCmpName.text.toString().trim(),
          "Email": txtEmail.text.toString().trim(),
          "MobileNo": txtMobileNo.text.toString().trim(),
          "CategoryId": CatId,
          "StateId": prefs.getString(cnst.session.CompanyStateId).toString(),
          "CityId": prefs.getString(cnst.session.CompanyCityName).toString(),
        });

        print("Category Id = ${CatId}");
        print("Category Name = ${CatName}");

        Services.PostServiceForSave("SendCompanyInfo.php", formData).then(
            (data) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (data.Data.toString() != "0" && data.Data.toString() != "") {
            await prefs.setString(cnst.session.CompnayName, txtCmpName.text.toString());
            await prefs.setString(cnst.session.CompnayEmail, txtEmail.text);
            await prefs.setString(cnst.session.CompnayMobile, txtMobileNo.text);
            await prefs.setString(cnst.session.CompanyCatId, CatId);
            await prefs.setString(cnst.session.CompanyCatName, CatName);
            await pr.hide();
            Navigator.pushReplacementNamed(context, "/Dashboard");
          } else {
            pr.hide();
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
    double ScreenHeight = MediaQuery.of(context).size.height;

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
                    image: ExactAssetImage("assets/image_01.png"),
                  ),
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
                                      ? CmpImage == "" ||
                                              CmpImage == null ||
                                              CmpImage == "null"
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
                            counterText: "",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(0.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          style: new TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      /*Container(
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
                      ),*/
                      SizedBox(
                        height: 50,
                        child: InputDecorator(
                          decoration: new InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(0),
                              )),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<categoryClass>(
                            hint: Text(
                              "${BusinessCategory}",
                              style: TextStyle(),
                            ),
                            value: _categoryClass,
                            onChanged: (val) {
                              setState(() {
                                _categoryClass = val;
                              });
                            },
                            items: _categoryList.map((categoryClass Source) {
                              return DropdownMenuItem<categoryClass>(
                                value: Source,
                                child: Text(
                                  "${Source.name}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Poppins",
                                      fontSize: 14),
                                ),
                              );
                            }).toList(),
                          )),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
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
                            /*Navigator.pushReplacementNamed(
                                context, "/Dashboard");*/

                            if (txtCmpName.text != "") {
                              if (txtEmail.text != "") {
                                if (validateEmail(txtEmail.text) == false) {
                                  if (txtMobileNo.text != "") {
                                    if (validateMobile(txtMobileNo.text) ==
                                        false) {
                                      if (_categoryClass != null ||
                                          BusinessCategory !=
                                              "Select Business Category") {
                                        sendCompanyInfo();
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: "Select Business Category",
                                          fontSize: 18,
                                          backgroundColor: Colors.black,
                                          gravity: ToastGravity.CENTER,
                                          textColor: Colors.white,
                                          toastLength: Toast.LENGTH_SHORT,
                                          timeInSecForIos: 3,
                                        );
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: "Enter Valid MobileNo",
                                        fontSize: 18,
                                        backgroundColor: Colors.black,
                                        gravity: ToastGravity.CENTER,
                                        textColor: Colors.white,
                                        toastLength: Toast.LENGTH_SHORT,
                                        timeInSecForIos: 3,
                                      );
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: "Enter MobileNo",
                                      fontSize: 18,
                                      backgroundColor: Colors.black,
                                      gravity: ToastGravity.CENTER,
                                      textColor: Colors.white,
                                      toastLength: Toast.LENGTH_SHORT,
                                      timeInSecForIos: 3,
                                    );
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Enter Valid Email",
                                    fontSize: 18,
                                    backgroundColor: Colors.black,
                                    gravity: ToastGravity.CENTER,
                                    textColor: Colors.white,
                                    toastLength: Toast.LENGTH_SHORT,
                                    timeInSecForIos: 3,
                                  );
                                }
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Enter Email",
                                  fontSize: 18,
                                  backgroundColor: Colors.black,
                                  gravity: ToastGravity.CENTER,
                                  textColor: Colors.white,
                                  toastLength: Toast.LENGTH_SHORT,
                                  timeInSecForIos: 3,
                                );
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg: "Enter Company Name",
                                fontSize: 18,
                                backgroundColor: Colors.black,
                                gravity: ToastGravity.CENTER,
                                textColor: Colors.white,
                                toastLength: Toast.LENGTH_SHORT,
                                timeInSecForIos: 3,
                              );
                            }
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
