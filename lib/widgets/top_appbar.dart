
import 'package:daeem/models/market.dart';
import 'package:daeem/provider/category_provider.dart';
import 'package:daeem/services/services.dart';
import 'package:daeem/widgets/rating.dart';
import 'package:flutter/cupertino.dart';

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final Market market;
  const CustomSliverAppBarDelegate(
    this.market,
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

  Widget buildAppBar(double shrinkOffset, context) {
    var _categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    return Opacity(
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
              _categoryProvider.closeProducts();
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
  }

  Widget buildBackground(double shrinkOffset, context) {
    var _categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    return Opacity(
        opacity: disappear(shrinkOffset),
        child: Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.8), BlendMode.darken),
                  image: new NetworkImage(market.cover!),
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
                    _categoryProvider.closeProducts();
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
  }

  Widget buildFloating(double shrinkOffset) => Opacity(
        opacity: disappear(shrinkOffset),
        child: Container(
          padding: EdgeInsets.all(10),
          height: 100,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 16,
                  offset: Offset(0, 4),
                )
              ]),
          child: Column(
            children: [
              Text(
                market.name!,
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
                  Text(market.hours,
                      style: GoogleFonts.ubuntu(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Color(0xff4A4B4D))),
                  Spacer(),
                  Rating((s) {}, 5).paddingOnly(right: 10),
                ],
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