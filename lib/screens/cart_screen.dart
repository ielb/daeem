import 'package:cached_network_image/cached_network_image.dart';
import 'package:daeem/models/item.dart';
import 'package:daeem/models/product.dart';
import 'package:daeem/provider/cart_provider.dart';
import 'package:daeem/provider/market_provider.dart';
import 'package:daeem/screens/checkout_screen.dart';
import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:ionicons/ionicons.dart';

class CartPage extends StatefulWidget {
  static const id = "cart";

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  ScrollController controller = ScrollController();
  bool called = false;
  late CartProvider cart;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!called) {
      cart = Provider.of<CartProvider>(context, listen: false);
    }
  }

  addToCart(Item item, BuildContext context) {
    cart.addToBasket(item);
    setState(() {});
  }

  removeFromCart(Item item, BuildContext context) {
    cart.removeFromBasket(item);
    setState(() {});
  }

  int? getItemCount(int id, BuildContext context) {
    Item data = cart.basket.singleWhere((element) => id == element.product.id,
        orElse: () => Item(product: Product()));
    return data.quantity;
  }

  checkout() async {
    await Provider.of<MarketProvider>(context, listen: false)
        .getDeliveryPrice(double.parse(cart.getSubPrice()));
    Navigator.pushNamed(context, CheckoutPage.id);
  }

  deleteItem(Item item) {}

  var address = true;
  var couponChecked = false;

  @override
  Widget build(BuildContext context) {
    var market = Provider.of<MarketProvider>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(CupertinoIcons.back),
            color: Config.black,
            iconSize: 26,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Shopping Cart",
            textAlign: TextAlign.center,
            style: GoogleFonts.ubuntu(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        body: market.isLoading
            ? Loading()
            : Container(
                height: screenSize(context).height,
                width: screenSize(context).width,
                color: Colors.white,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  controller: controller,
                  child: cart.basket.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: cart.basket.length,
                              itemBuilder: (context, index) {
                                return cartItem(item: cart.basket[index],onTap: (){
                                  print("item");
                                });
                              },
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Image.asset(
                              "assets/empty_cart.png",
                              height: 250,
                            ).paddingOnly(top: 50, bottom: 20),
                            Text("No products",
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey))
                                .paddingOnly(bottom: 10),
                            Container(
                                    width: 300,
                                    child: Text(
                                        "You haven't added any product to your cart",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.ubuntu(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey)))
                                .paddingOnly(bottom: 20),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 200,
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Config.color_2,
                                ),
                                child: Center(
                                  child: Text(
                                    "Start shopping",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                ),
              ),
        bottomNavigationBar: cart.basket.isNotEmpty
            ? Container(
                height: 60,
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: MaterialButton(
                  onPressed: () {
                    checkout();
                  },
                  height: 50,
                  elevation: 0,
                  splashColor: Config.color_2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Config.color_2,
                  child: Center(
                    child: Text(
                      "Process to checkout",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ))
            : null);
  }

 

  Widget cartItem({required Item item, Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 70,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 4),
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top:5,left: 5,bottom: 5),
                height: 70,
                child: ClipRRect(
                  child: CachedNetworkImage(
                      imageUrl: item.product.image ?? '',
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                      value: downloadProgress.progress)
                                  .center(),
                      errorWidget: (context, url, error) => Image.asset(
                            "assets/placeholder.png",
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.cover,
                          )),
                  borderRadius: BorderRadius.circular(15),
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 140,
                  child: Text("${item.product.name}",
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.ubuntu(
                              fontSize: 18, fontWeight: FontWeight.w500))
                      .paddingOnly(left: 5),
                ),
                Text( "${item.product.price} DH/${item.product.hasVariant==1 ? item.product.variants[1].option?.toLowerCase(): 'Item'}",
                        style: GoogleFonts.ubuntu(
                            fontSize: 16, fontWeight: FontWeight.w400))
                    .paddingOnly(left: 5),
              ],
            ),
            Spacer(),
            InkWell(
              onTap: () {
                removeFromCart(item, context);
              },
              child: Icon(Ionicons.remove),
            ).paddingOnly(right: 10),
            Text("${item.quantity}",
                style: GoogleFonts.ubuntu(
                    fontSize: 20, fontWeight: FontWeight.w500)),
            InkWell(
              onTap: () {
                addToCart(item, context);
              },
              child: Icon(Ionicons.add),
            ).paddingOnly(left: 10),
            Spacer(),
            InkWell(
              onTap: () {
                deleteItem(item);
              },
              child: Icon(
                Ionicons.trash_outline,
                color: Colors.redAccent,
              ),
            ).paddingOnly(right: 10),
          ],
        ),
      ),
    );
  }
}
