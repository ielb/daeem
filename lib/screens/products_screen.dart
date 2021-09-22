import 'package:daeem/services/services.dart';
import 'package:daeem/widgets/rating.dart';
import 'package:flutter/cupertino.dart';

class ProductsPage extends StatefulWidget {
  static const id = "products";

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late TextEditingController _searchController;
  bool _isClosed = false;
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          ///App bar
          SliverPersistentHeader(
            delegate: CustomSliverAppBarDelegate(200),
            pinned: true,
          ),

          ///Closed sign
          if (_isClosed)
            SliverToBoxAdapter(
                child: Container(
              height: 55,
              width: 300,
              margin: EdgeInsets.only(left: 20, right: 20, top: 80),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Config.closed,
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                            text: TextSpan(
                                text: "This store is closed at the moment.",
                                style: GoogleFonts.ubuntu(
                                    color: Colors.black,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w400),
                                children: [
                              TextSpan(
                                  text: "Looking for something similar?",
                                  style: GoogleFonts.ubuntu(
                                      color: Colors.black,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w600))
                            ])),
                        Text("Explore stores near you",
                                style:
                                    GoogleFonts.ubuntu(color: Config.color_1))
                            .align(alignment: Alignment.bottomLeft)
                            .paddingOnly(right: 105)
                      ])
                ],
              ),
              decoration: BoxDecoration(
                  color: Color(0xffFFF3DA),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      spreadRadius: 2,
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    )
                  ]),
            )),

          ///SearchField
          SliverToBoxAdapter(
              child: SearchInput(_searchController, "Search for supermarket",
                      screenSize(context).width * .81, CupertinoIcons.search)
                  .paddingOnly(left: 20, right: 20, top: _isClosed ? 10 : 80)),
          _content()
        ],
      ),
    );
  }

  ///Content list
  Widget _content() => SliverToBoxAdapter(
        child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: 5,
          itemExtent: 80,
          itemBuilder: (context, index) {
            return ListTile(
                minVerticalPadding: 5,
                leading: Container(
                  height: 60,
                  width: 60,
                  padding: EdgeInsets.all(5),
                  child: Image.network(
                      "https://offautan-uc1.azureedge.net/-/media/images/off/ph/products-en/products-landing/landing/off_overtime_product_collections_large_2x.jpg?la=en-ph",width: 55,height: 55,),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          spreadRadius: 2,
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        )
                      ]),
                ),
                title: Text("Something"),
                subtitle: Text("15DH"),
                trailing: Container(
                  width: 120,
                  child: Row(
                    children: [
                      Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(35),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  spreadRadius: 2,
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                )
                              ]),
                          child: IconButton(
                              iconSize: 18,
                              onPressed: () {},
                              icon: Icon(CupertinoIcons.minus))
                              .center()),
                      SizedBox(
                        width: 10,
                      ),
                      Text("1x"),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(35),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  spreadRadius: 2,
                                  blurRadius: 16,
                                  offset: Offset(0, 4),
                                )
                              ]),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(CupertinoIcons.add),
                          iconSize: 18,
                        ) .center()
                      )
                    ],
                  ),
                ));
          },
        ),
      );
}

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  const CustomSliverAppBarDelegate(
    this.expandedHeight,
  );

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final size = 120;
    final top = expandedHeight - shrinkOffset - size / 2;

    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        buildBackground(shrinkOffset, context),
        buildAppBar(shrinkOffset, context),
        Positioned(
          top: top,
          left: 20,
          right: 20,
          child: buildFloating(shrinkOffset),
        ),
      ],
    );
  }

  double appear(double shrinkOffset) => shrinkOffset / expandedHeight;

  double disappear(double shrinkOffset) => 1 - shrinkOffset / expandedHeight;

  Widget buildAppBar(double shrinkOffset, context) => Opacity(
        opacity: appear(shrinkOffset),
        child: AppBar(
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
                Navigator.pop(context);
              },
              iconSize: 30,
              color: Config.darkBlue,
              icon: Icon(CupertinoIcons.back)),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {},
                iconSize: 26,
                color: Config.darkBlue,
                icon: Icon(CupertinoIcons.bell_fill)),
          ],
        ),
      );

  Widget buildBackground(double shrinkOffset, context) => Opacity(
      opacity: disappear(shrinkOffset),
      child: Container(
          decoration: new BoxDecoration(
              image: new DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.8), BlendMode.darken),
                image: new ExactAssetImage(Config.margane),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15))),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Delivering to",
                  style: GoogleFonts.ubuntu(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.white),
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
                            color: Config.white),
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
                  Navigator.pop(context);
                },
                iconSize: 30,
                color: Config.white,
                icon: Icon(CupertinoIcons.back)),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () {},
                  iconSize: 26,
                  color: Config.white,
                  icon: Icon(CupertinoIcons.bell_fill)),
            ],
          )));

  Widget buildFloating(double shrinkOffset) => Opacity(
        opacity: disappear(shrinkOffset),
        child: Container(
          padding: EdgeInsets.all(10),
          height: 120,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  spreadRadius: 2,
                  blurRadius: 16,
                  offset: Offset(0, 4),
                )
              ]),
          child: Column(
            children: [
              Text(
                "Marjane, Route Rabat",
                style: GoogleFonts.ubuntu(
                    color: Config.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(CupertinoIcons.clock, size: 18, color: Color(0xff4A4B4D))
                      .paddingOnly(right: 3, left: 10),
                  Text("09:00 - 22:00",
                      style: GoogleFonts.ubuntu(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Color(0xff4A4B4D))),
                  Spacer(),
                  Rating((s) {}, 5).paddingOnly(right: 10),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Please do not exceed 15Kg",
                style: GoogleFonts.ubuntu(
                    color: Config.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
      );

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 30;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
