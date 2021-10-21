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

  checkout() async{
    await Provider.of<MarketProvider>(context, listen: false).getDeliveryPrice(double.parse(cart.getFinalPrice()));
    Navigator.pushReplacementNamed(context, CheckoutPage.id);
  }

  deleteItem(Item item) {}

  var address = true;
  var couponChecked = false;

  @override
  Widget build(BuildContext context) {
    var market = Provider.of<MarketProvider>(context, listen: false);
    market.getDeliveryPrice(double.parse(cart.getFinalPrice()));
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
                                return content(item: cart.basket[index]);
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
                              color: Config.color_2,),
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

  Widget content({required Item item, Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
          minVerticalPadding: 5,
          leading: Container(
            height: 60,
            width: 60,
            padding: EdgeInsets.all(5),
            child: Image.network(
              item.product.image ??
                  "https://static.thenounproject.com/png/741653-200.png",
              width: 55,
              height: 55,
            ),
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
          title: Text(item.product.name!),
          subtitle: Text(item.product.price! + " MAD"),
          trailing: Container(
            width: 145,
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
                      onPressed: () => removeFromCart(item, context),
                      icon: Icon(CupertinoIcons.minus),
                      color: Colors.redAccent,
                    ).center()),
                Spacer(),
                Text(" ${item.quantity}x"),
                Spacer(),
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
                      onPressed: () {
                        addToCart(item, context);
                      },
                      icon: Icon(CupertinoIcons.add),
                      color: Config.color_2,
                      iconSize: 18,
                    ).center()),
                Spacer(),
                IconButton(
                    onPressed: deleteItem(item),
                    icon: Icon(
                      Ionicons.trash_bin_outline,
                      color: Colors.redAccent.shade100,
                    ))
              ],
            ),
          )),
    );
  }
}
