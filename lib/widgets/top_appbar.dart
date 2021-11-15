import 'package:daeem/models/market.dart';
import 'package:daeem/provider/auth_provider.dart';
import 'package:daeem/provider/cart_provider.dart';
import 'package:daeem/provider/category_provider.dart';
import 'package:daeem/provider/market_provider.dart';
import 'package:daeem/screens/cart_screen.dart';
import 'package:daeem/screens/checkout_screen.dart';
import 'package:daeem/widgets/rating.dart';
import 'package:flutter/cupertino.dart';
import 'package:daeem/services/services.dart';
import 'package:ionicons/ionicons.dart';
import '/extensions/extensions.dart';

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final Store market;
  final bool isMarket;

  final bool isSub;
  const CustomSliverAppBarDelegate(this.market, this.expandedHeight,
      {this.isMarket = false, this.isSub = false});

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
    var _categoryProvider = Provider.of<CategoryProvider>(
      context,
    );
    var cart = Provider.of<CartProvider>(
      context,
    );
    var _marketProvider = Provider.of<StoreProvider>(
      context,
    );
    var auth = Provider.of<AuthProvider>(
      context,
    );
    return Opacity(
      opacity: appear(shrinkOffset),
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "${market.name}",
          style: GoogleFonts.ubuntu(
              fontSize: 24, fontWeight: FontWeight.w500, color: Config.black),
        ),
        leading: IconButton(
            onPressed: () {
              if (!isMarket) {
                _categoryProvider.closeProducts();
                if (!isSub) _categoryProvider.closeSub();
                Navigator.of(context).pop(context);
              } else {
                _categoryProvider.close();
                _categoryProvider.closeSub();
                _marketProvider.unSetCurrentMarket();
                if (cart.isCartEmpty()) {
                  _categoryProvider.closeProducts();
                  Navigator.of(context).pop(context);
                } else {
                  if (auth.isAuth()) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Container(
                              height: 400,
                              width: 400,
                              child: Column(
                                children: [
                                  Image.asset("assets/cart.png").paddingAll(25),
                                  Text("Your cart will be deleted",
                                      style: GoogleFonts.ubuntu(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                  Text("Please complete your order",
                                          style: GoogleFonts.ubuntu(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey))
                                      .paddingAll(20),
                                  Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          cart.clearCart();
                                          Navigator.of(context)
                                              .pushReplacementNamed(Home.id);
                                        },
                                        child: Text(
                                          "Cancel anyway",
                                          style: GoogleFonts.ubuntu(
                                              fontSize: 14,
                                              color: Colors.red.shade500),
                                        ),
                                      ),
                                      Spacer(),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, CheckoutPage.id);
                                        },
                                        child: Text(
                                          "Checkout",
                                          style: GoogleFonts.ubuntu(
                                              fontSize: 14,
                                              color: Config.color_2),
                                        ),
                                      ),
                                    ],
                                  ).paddingOnly(left: 20, right: 20, bottom: 20)
                                ],
                              ),
                            ));
                      },
                    );
                  } else {
                    cart.clearCart();
                    Navigator.of(context).pushReplacementNamed(Home.id);
                  }
                }
              }
            },
            iconSize: 30,
            color: Config.black,
            icon: Icon(CupertinoIcons.back)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, CartPage.id);
            },
            child: Stack(children: <Widget>[
              Icon(Ionicons.bag_handle, size: 26, color: Config.black)
                  .paddingOnly(top: 10, right: 10),
              cart.basket.length != 0
                  ? Positioned(
                      right: 2,
                      top: 5,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: Center(
                          child: Text(
                            '${cart.basket.length}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget buildBackground(double shrinkOffset, context) {
    var _categoryProvider = Provider.of<CategoryProvider>(
      context,
    );
    var __marketProvider = Provider.of<StoreProvider>(
      context,
    );
    var cart = Provider.of<CartProvider>(
      context,
    );
    var auth = Provider.of<AuthProvider>(
      context,
    );
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
              title: Text(
                "Supermarket",
                style: GoogleFonts.ubuntu(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Config.white),
              ),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    if (!isMarket) {
                      _categoryProvider.closeProducts();
                      if (!isSub) _categoryProvider.closeSub();
                      Navigator.of(context).pop(context);
                    } else {
                      _categoryProvider.close();
                      _categoryProvider.closeSub();
                      __marketProvider.unSetCurrentMarket();
                      if (cart.isCartEmpty()) {
                        _categoryProvider.closeProducts();
                        Navigator.of(context).pop(context);
                      } else {
                        if (auth.isAuth()) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Container(
                                    height: 400,
                                    width: 400,
                                    child: Column(
                                      children: [
                                        Image.asset("assets/cart.png")
                                            .paddingAll(25),
                                        Text("Your cart will be deleted",
                                            style: GoogleFonts.ubuntu(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black)),
                                        Text("Please complete your order",
                                                style: GoogleFonts.ubuntu(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey))
                                            .paddingAll(20),
                                        Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  cart.clearCart();
                                                  Navigator.of(context)
                                                      .pop(context);
                                                },
                                                child: Text(
                                                  "Cancel anyway",
                                                  style: GoogleFonts.ubuntu(
                                                      fontSize: 14,
                                                      color:
                                                          Colors.red.shade500),
                                                ),
                                                style: OutlinedButton.styleFrom(
                                                  primary: Colors.red.shade400,
                                                  side: BorderSide(
                                                      color:
                                                          Colors.red.shade400,
                                                      width: 1.5),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(6),
                                                  ),
                                                  textStyle: GoogleFonts.ubuntu(
                                                      fontSize: 14),
                                                )),
                                            Spacer(),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, CheckoutPage.id);
                                              },
                                              child: Text(
                                                "Checkout",
                                                style: GoogleFonts.ubuntu(
                                                    fontSize: 14,
                                                    color: Config.color_2),
                                              ),
                                            ),
                                          ],
                                        ).paddingOnly(
                                            left: 20, right: 20, bottom: 20)
                                      ],
                                    ),
                                  ));
                            },
                          );
                        } else {
                          cart.clearCart();
                          Navigator.of(context).pop(context);
                        }
                      }
                    }
                  },
                  iconSize: 30,
                  color: Config.white,
                  icon: Icon(CupertinoIcons.back)),
              automaticallyImplyLeading: false,
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, CartPage.id);
                  },
                  child: Stack(children: <Widget>[
                    Icon(Ionicons.bag_handle, size: 26, color: Config.white)
                        .paddingOnly(top: 10, right: 10),
                    cart.basket.length != 0
                        ? Positioned(
                            right: 2,
                            top: 5,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              child: Center(
                                child: Text(
                                  '${cart.basket.length}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ]),
                ),
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
