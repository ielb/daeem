import 'package:daeem/services/services.dart';
import 'package:daeem/widgets/drawer.dart';
import 'package:daeem/widgets/market_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
 static const id = "home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userName = "John";
  late TextEditingController _controller;
  double value = 3.5;
  late ScrollController _scrollController;
  int itemCount = 5;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  void initState() {
    _controller = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          itemCount++;
        });
        print(itemCount);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _key,
        drawer: CustomDrawer(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Delivering to",
                style: GoogleFonts.ubuntu(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey.shade500),
              ).align(alignment: Alignment.topLeft),
              GestureDetector(
                onTap: () {
                  ///Todo:Open Map
                },
                child: Row(
                  children: [
                    Text(
                      "Current Location",
                      style: GoogleFonts.ubuntu(
                          fontSize: 22,
                          fontWeight: FontWeight.w300,
                          color: Config.darkBlue),
                    ),
                    Icon(
                      CupertinoIcons.chevron_down,
                      color: Config.color_2,
                      size: 20,
                    ).paddingOnly(left: 5, top: 5)
                  ],
                ),
              )
            ],
          ),
          leading: IconButton(
              onPressed: () {
                _key.currentState!.openDrawer();
              },
              iconSize: 30,
              color: Config.darkBlue,
              icon: Icon(CupertinoIcons.bars)),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {},
                iconSize: 26,
                color: Config.darkBlue,
                icon: Icon(CupertinoIcons.bell_fill)),
          ],

        ),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 140,
              elevation: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  height: 300,
                  child: Column(
                      children: [
                        ///Todo:Update the user
                        Text(
                          "Welcome, $userName!",
                          style: GoogleFonts.ubuntu(
                              fontSize: 26,
                              fontWeight: FontWeight.w300,
                              color: Color(0xff4A4B4D)),
                        ).paddingAll(15).align(alignment: Alignment.topLeft),
                        SearchInput(
                            _controller,
                            "Search for supermarket",
                            screenSize(context).width * .91,
                            CupertinoIcons.search)
                            .paddingOnly(bottom: 10),
                      ]
                  ),
                ),
              ),

            ),
            _content()
          ],
        ),

      ),
    );
  }
  Widget _content() =>SliverToBoxAdapter(
    child:  ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      primary: false,
      itemCount: 5,
      itemExtent: 250,
      itemBuilder: (context, index) {
        return MarketWidget("Marjane", Config.margane,
          "Marjane, Route Rabat", "09:00 - 20:00", 3,).paddingOnly(left: 20, right: 20, bottom: 20);
      },
    ),
  );

}