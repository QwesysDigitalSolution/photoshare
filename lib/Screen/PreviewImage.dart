import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photoshare/Common/Constants.dart' as cnst;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;
class PreviewImage extends StatefulWidget {
  var data;

  PreviewImage({this.data});

  @override
  _PreviewImageState createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  String posi;
  Alignment alignment;
  GlobalKey _globalKey = new GlobalKey();
  String CmpLogo = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    posi = widget.data["position"];
    if (widget.data["position"].toString() == "topLeft") {
      alignment = Alignment.topLeft;
    } else if (widget.data["position"].toString() == "topRight") {
      alignment = Alignment.topRight;
    } else if (widget.data["position"].toString() == "bottomLeft") {
      alignment = Alignment.bottomLeft;
    } else {
      alignment = Alignment.bottomRight;
    }

    getLocalData();
  }

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      CmpLogo = prefs.getString(cnst.session.Image);
    });
  }

   _capturePng() async {
    try {
      print('inside');

      RenderRepaintBoundary boundary =
      _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      /*var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);*/
      await Share.file(
          'Photoshare', 'photoshare.png', byteData.buffer.asUint8List(), 'image/png',
          text: 'My optional text.');
    } catch (e) {
      print(e);
    }
  }

  _download() async {
    RenderRepaintBoundary boundary =
    _globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData =
    await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();

    final result =
    await ImageGallerySaver.saveImage(Uint8List.fromList(pngBytes));
    print(result);
  }
  @override
  Widget build(BuildContext context) {
    double widt = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              RepaintBoundary(
                key: _globalKey,
                child: Container(
                  height: widt - (widt * 0.139),
                  width: MediaQuery.of(context).size.width,
                  //color: Colors.red,
                  child: Stack(children: <Widget>[
                    Center(child: Image.network("${widget.data["Image"]}")),
                    Align(
                      alignment: alignment,
                      child: Image.network(
                        "${CmpLogo}",
                        alignment: alignment,
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ]),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 10),
                  height: widt * 0.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    color: Colors.black,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap:(){
                          _download();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.file_download,
                                size: 20,
                                color: Colors.white,
                              ),
                              Text(
                                "Download",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          _capturePng();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.share,
                                size: 20,
                                color: Colors.white,
                              ),
                              Text(
                                "Share",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Icon(
                                Icons.close,
                                color: cnst.app_primary_material_color[600],
                                size: 17,
                              ),
                            ),
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
