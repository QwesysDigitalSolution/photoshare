import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:photoshare/Screen/PreviewImage.dart';

class BusinessAndFestivalImages extends StatefulWidget {
  var catData;
  int index;

  BusinessAndFestivalImages(this.catData, this.index);

  @override
  _BusinessAndFestivalImagesState createState() =>
      _BusinessAndFestivalImagesState();
}

class _BusinessAndFestivalImagesState extends State<BusinessAndFestivalImages> {
  @override
  Widget build(BuildContext context) {
    /*return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PreviewImage(data: widget.catData)));
      },
      child: Card(
        elevation: 3,
        margin: EdgeInsets.all(2),
        shape: RoundedRectangleBorder(
          //side: BorderSide(color: cnst.appcolor)),
          side: BorderSide(width: 0.10, color: Colors.transparent),
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(10.0),
          child: widget.catData["Image"].toString() != "" &&
                  widget.catData["Image"].toString() != "null"
              ? FadeInImage.assetNetwork(
                  placeholder: "assets/loading.gif",
                  image: "${widget.catData["Image"]}",
                  fit: BoxFit.cover,
                )
              : Container(
                  height: 140,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  width: MediaQuery.of(context).size.width / 2,
                  child: Center(
                    child: Text(
                      'No Image Available',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                  ),
                ),
        ),
      ),
    );*/

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PreviewImage(data: widget.catData)));
      },
      child: AnimationConfiguration.staggeredGrid(
        duration: const Duration(milliseconds: 1000),
        columnCount: 2,
        position: widget.index,
        child: SlideAnimation(
          verticalOffset: 50.0,
          child: FlipAnimation(
            child: Card(
              elevation: 3,
              margin: EdgeInsets.all(2),
              shape: RoundedRectangleBorder(
                //side: BorderSide(color: cnst.appcolor)),
                side: BorderSide(width: 0.10, color: Colors.transparent),
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
              ),
              child: Container(
                //width: MediaQuery.of(context).size.width / 2,
                //width: 170,
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      widget.catData["Image"].toString() != "" &&
                              widget.catData["Image"].toString() != "null"
                          ? FadeInImage.assetNetwork(
                              placeholder: "assets/loading.gif",
                              image: "${widget.catData["Image"]}",
                              fit: BoxFit.fill,
                            )
                          : Container(
                              height: 140,
                              padding: EdgeInsets.only(left: 20, right: 20),
                              width: MediaQuery.of(context).size.width / 2,
                              child: Center(
                                child: Text(
                                  'No Image Available',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 20),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
