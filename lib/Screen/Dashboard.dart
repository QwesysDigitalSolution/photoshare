import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photoshare/common/Services.dart';
import 'package:photoshare/components/BusinessAndFestivalImages.dart';
import 'package:photoshare/utils/NoDataComponent.dart';
import 'package:photoshare/utils/Shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:photoshare/Common/Constants.dart' as cnst;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  ScrollController scrollController = new ScrollController();
  String appBarTitle = "";
  double wid;

  String CategoryId = "", UserImage = "";
  bool isLoading = true;
  List catData = new List();
  List fasData = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //wid=MediaQuery.of(context).size.width;
    //scrollController = new ScrollController();
    scrollController.addListener(() => setState(() {}));
    getLocalData();
    getApiData();
  }

  getApiData() async {}

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      CategoryId = prefs.getString(cnst.session.CompanyCatId);
      UserImage = prefs.getString(cnst.session.UserImage);
    });
    await getBusinessImages();
    await getFestivalImages();
  }

  showMsg(String msg, {String title = 'Photoshare'}) {
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

  getBusinessImages() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //pr.show();
        List formData = [
          {"key": "CategoryId", "value": CategoryId.toString()},
        ];
        print("GetBusinessImages Data = ${formData}");
        //pr.show();
        setState(() {
          isLoading = true;
        });
        Services.GetServiceForList("GetBusinessImages.php", formData).then(
            (data) async {
          //pr.hide();
          if (data.length > 0) {
            setState(() {
              catData = data;
            });
            setState(() {
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          //pr.isShowing() ? pr.hide() : null;
          showMsg("Try Again.");
        });
      }
    } on SocketException catch (_) {
      //pr.isShowing() ? pr.hide() : null;
      setState(() {
        isLoading = false;
      });
      showMsg("No Internet Connection.");
    }
  }

  getFestivalImages() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //pr.show();
        List formData = [];
        print("GetFestivalImages Data = ${formData}");
        //pr.show();
        setState(() {
          isLoading = true;
        });
        Services.GetServiceForList("GetFestivalImages.php", formData).then(
            (data) async {
          //pr.hide();
          if (data.length > 0) {
            setState(() {
              fasData = data;
            });
            setState(() {
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          //pr.isShowing() ? pr.hide() : null;
          showMsg("Try Again.");
        });
      }
    } on SocketException catch (_) {
      //pr.isShowing() ? pr.hide() : null;
      setState(() {
        isLoading = false;
      });
      showMsg("No Internet Connection.");
    }
  }

  String getName() {
    getLocalData();
    return "Profile";
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double widt = MediaQuery.of(context).size.width;
    wid = widt;
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          //controller: scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                child: SliverSafeArea(
                  top: false,
                  sliver: SliverAppBar(
                    //expandedHeight: widt * 0.35,
                    expandedHeight: widt * 0.0,
                    floating: false,
                    pinned: true,
                    forceElevated: innerBoxIsScrolled,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text("Dashboard",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          )),
                      background: Image.asset(
                        "assets/qwesyslogo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    actions: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, "/UpdateBusinessProfile");
                        },
                        child: new Padding(
                          padding:
                              EdgeInsets.only(top: 3, bottom: 3, right: 15),
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 30.0,
                                width: 30.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                  image: new DecorationImage(
                                    image: new NetworkImage("${UserImage}"),
                                    fit: BoxFit.cover,
                                  ),
                                  border: Border.all(
                                      color: Colors.black, width: 1.0),
                                ),
                              ),
                              //Text("${getName()}",),
                              Text(
                                "Profile",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    leading: _buildLeading(),
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: "Business Images"),
                      Tab(text: "Festival Images"),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: new TabBarView(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: isLoading
                    ? ShimmerGridListSkeleton(
                        length: 10,
                        isBottomLinesActive: false,
                        isCircularImage: false,
                      )
                    : catData.length > 0 && catData != null
                        ? AnimationLimiter(
                            child: StaggeredGridView.countBuilder(
                              padding: const EdgeInsets.only(
                                  left: 4, right: 4, top: 5),
                              crossAxisCount: 4,
                              itemCount: catData.length,
                              staggeredTileBuilder: (_) => StaggeredTile.fit(2),
                              mainAxisSpacing: 3,
                              crossAxisSpacing: 3,
                              itemBuilder: (BuildContext context, int index) {
                                return BusinessAndFestivalImages(
                                    catData[index], index);
                              },
                            ),
                          )
                        : NoDataComponent(),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: isLoading
                    ? ShimmerGridListSkeleton(
                        length: 10,
                        isBottomLinesActive: false,
                        isCircularImage: false,
                      )
                    : fasData.length > 0 && fasData != null
                        ? AnimationLimiter(
                            child: StaggeredGridView.countBuilder(
                              padding: const EdgeInsets.only(
                                  left: 4, right: 4, top: 5),
                              crossAxisCount: 4,
                              itemCount: fasData.length,
                              staggeredTileBuilder: (_) => StaggeredTile.fit(2),
                              mainAxisSpacing: 3,
                              crossAxisSpacing: 3,
                              itemBuilder: (BuildContext context, int index) {
                                return BusinessAndFestivalImages(
                                    fasData[index], index);
                              },
                            ),
                          )
                        : NoDataComponent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActions() {
    try {
      Widget profile = new GestureDetector(
        onTap: () {
          /*scrollController = new ScrollController();
              scrollController.addListener(() => setState(() {}));*/
          //scrollController.dispose();
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Column(
            children: <Widget>[
              Container(
                height: 30.0,
                width: 30.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                  image: new DecorationImage(
                    image: new ExactAssetImage("assets/logo.png"),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: Colors.black, width: 2.0),
                ),
              ),
              Text("Profile"),
            ],
          ),
        ),
      );

      double scale;
      if (scrollController.hasClients) {
        scale = scrollController.offset / wid * 2.5;
        scale = scale * 2;
        if (scale > 1) {
          scale = 1.0;
        }
      } else {
        scale = 0.0;
      }

      return new Transform(
        transform: new Matrix4.identity()..scale(scale, scale),
        alignment: Alignment.center,
        child: profile,
      );
    } catch (e) {
      print(e);
    }
  }

  Widget _buildLeading() {
    Widget profile = new GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
          height: 30.0,
          width: 40.0,
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new ExactAssetImage("assets/qwesyslogo.png"),
              fit: BoxFit.contain,
            ),
            //border: Border.all(color: Colors.black, width: 2.0),
          ),
        ),
      ),
    );

    double scale;
    if (scrollController.hasClients) {
      scale = scrollController.offset / wid * 2.5;
      scale = scale * 2;
      if (scale > 1) {
        scale = 1.0;
      }
    } else {
      scale = 0.0;
    }

    return new Transform(
      transform: new Matrix4.identity()..scale(scale, scale),
      alignment: Alignment.center,
      child: profile,
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
