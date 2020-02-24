import 'package:flutter/material.dart';
import 'package:photoshare/Screen/PreviewImage.dart';

class BusinessAndFestivalImages extends StatefulWidget {
  var catData;

  BusinessAndFestivalImages(this.catData);

  @override
  _BusinessAndFestivalImagesState createState() =>
      _BusinessAndFestivalImagesState();
}

class _BusinessAndFestivalImagesState extends State<BusinessAndFestivalImages> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Navigator.pushNamed(context, "/PreviewImage");
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
    );
  }
}
