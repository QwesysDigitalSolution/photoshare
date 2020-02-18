import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  ScrollController scrollController;
  String appBarTitle = "";
  double wid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //wid=MediaQuery.of(context).size.width;
    scrollController = new ScrollController();
    scrollController.addListener(() => setState(() {}));
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
          controller: scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                child: SliverSafeArea(
                  top: false,
                  sliver: SliverAppBar(
                    expandedHeight: widt * 0.35,
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
                      new Padding(
                        padding: EdgeInsets.all(5.0),
                        child: _buildActions(),
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
                child: GridView.builder(
                    itemCount: 10,
                    //shrinkWrap: true,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio:
                      MediaQuery.of(context).size.width / (430),
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/qwesyslogo.png',
                          image: "http://media1.santabanta.com/full1/Indian%20%20Celebrities(M)/Hrithik%20Roshan/hrithik-roshan-129a.jpg",
                          height: 140,
                          width: MediaQuery.of(context).size.width / 2,
                          fit: BoxFit.fill,
                        ),
                      );
                    }),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: GridView.builder(
                    itemCount: 10,
                    //shrinkWrap: true,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio:
                      MediaQuery.of(context).size.width / (430),
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/qwesyslogo.png',
                          image: "http://media1.santabanta.com/full1/Indian%20%20Celebrities(M)/Hrithik%20Roshan/hrithik-roshan-129a.jpg",
                          height: 140,
                          width: MediaQuery.of(context).size.width / 2,
                          fit: BoxFit.fill,
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActions() {
    Widget profile = new GestureDetector(
      onTap: () {},
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
