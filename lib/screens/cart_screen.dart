import 'package:daeem/models/coupon.dart';
import 'package:daeem/models/item.dart';
import 'package:daeem/models/product.dart';
import 'package:daeem/provider/auth_provider.dart';
import 'package:daeem/provider/cart_provider.dart';
import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/provider/market_provider.dart';
import 'package:daeem/screens/checkout_screen.dart';
import 'package:daeem/screens/product_details.dart';
import 'package:daeem/services/services.dart';
import 'package:daeem/widgets/cart_item_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CartPage extends StatefulWidget {
  static const id = "cart";

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  ScrollController controller = ScrollController();
  late TextEditingController _controller;
  bool called = false;
  bool couponChecked = false;
  String discout = '';
  late ClientProvider client ;
  late CartProvider cart;
  late StoreProvider market;
  late AuthProvider auth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!called) {
      cart = Provider.of<CartProvider>(context);
      market = Provider.of<StoreProvider>(context);
      auth = Provider.of<AuthProvider>(context);
      client =  Provider.of<ClientProvider>(context);
      _controller = TextEditingController();
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => CircularProgressIndicator(
                  color: Config.color_2,
                ).center());
        await Provider.of<StoreProvider>(context, listen: false)
            .getDeliveryPrice(double.parse(cart.getSubPrice()));
        if (mounted) Navigator.pop(context);
      });
      setState(() {
        called = true;
      });
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

  checkCoupon() async {
    FocusScope.of(context).requestFocus(FocusNode());
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
              onWillPop: () async => false,
              child: CircularProgressIndicator(
                color: Config.color_2,
              ).center(),
            ));
    Coupon? coupon = await cart.checkCoupon(_controller.text);
    if (coupon == null) {
      Navigator.pop(context);
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "The coupon is wrong",
        ),
      );
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.success(
          message: "Nice you saved ${coupon.discount_price} MAD",
        ),
      );
      setState(() {
        couponChecked = true;
        discout = coupon.discount_price ?? '';
        Navigator.pop(context);
      });
    }
  }

  int? getItemCount(int id, BuildContext context) {
    Item data = cart.basket.singleWhere((element) => id == element.product.id,
        orElse: () => Item(product: Product()));
    return data.quantity;
  }

  checkout() async {
    if (auth.isAuth()) {
      client.getClientAddress(client.client!);
      Navigator.pushNamed(context, CheckoutPage.id);
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.info(
          message: "You need to be logged in to checkout",
          textStyle: GoogleFonts.ubuntu(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              elevation: 1,
              titleTextStyle: GoogleFonts.ubuntu(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
              title: Text("Please Sign in"),
              content: Text("Please Sign in to continue"),
              contentTextStyle:
                  GoogleFonts.ubuntu(fontSize: 18, color: Colors.black),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.ubuntu(
                        fontSize: 16, color: Colors.red.shade400),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    "Sign in",
                    style:
                        GoogleFonts.ubuntu(fontSize: 16, color: Config.color_2),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, Login.id, arguments: true);
                  },
                ),
              ],
            );
          });
    }
  }

  deleteItem(Item item) {
    if (cart.basket.length == 1) {
      showDialog(
          context: context,
          builder: (context) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                ),
                child: Container(
                  height: 200,
                  width: screenSize(context).width * .9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Oh, No ! 😞",
                        style: GoogleFonts.ubuntu(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ).paddingOnly(top: 15, left: 15),
                      Spacer(),
                      Text(
                        "Did you pressed here by wrong or want to add other products ?",
                        style: GoogleFonts.ubuntu(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                      ).paddingOnly(left: 15, right: 5),
                      Spacer(
                        flex: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Undo',
                                style: GoogleFonts.ubuntu(
                                    color: Config.color_2,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16),
                              )),
                          TextButton(
                              onPressed: () {
                                var result = cart.deleteItem(item);
                                if (result) {
                                  Navigator.of(context).pop();
                                } else {
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Text(
                                'Empty cart',
                                style: GoogleFonts.ubuntu(
                                    color: Colors.redAccent.shade400,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16),
                              ))
                        ],
                      ).align(alignment: Alignment.centerRight)
                    ],
                  ).paddingAll(5),
                ),
              ));
    } else
      cart.deleteItem(item);
  }

  @override
  Widget build(BuildContext context) {
    var market = Provider.of<StoreProvider>(context);
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
                                return CartItem(
                                    item: cart.basket[index],
                                    onAdd: addToCart,
                                    onRemove: removeFromCart,
                                    onDelete: deleteItem,
                                    onTap: () {
                                      Navigator.pushNamed(context, ProductDetails.id,
                                          arguments: cart.basket[index].product);
                                    });
                              },
                            ),
                            Text(
                              "Coupon",
                              style: GoogleFonts.ubuntu(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ).paddingOnly(top: 10, bottom: 20, left: 20),
                            Row(
                              children: [
                                Container(
                                    width: screenSize(context).width * .91,
                                    decoration: BoxDecoration(boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade100,
                                        spreadRadius: 2,
                                        blurRadius: 16,
                                        offset: Offset(0, 4),
                                      )
                                    ]),
                                    child: TextField(
                                      controller: _controller,
                                      decoration: InputDecoration(
                                        errorStyle: GoogleFonts.ubuntu(
                                            color: Colors.red, fontSize: 12),
                                        contentPadding: EdgeInsets.all(1),
                                        filled: true,
                                        fillColor: Config.white,
                                        hintText: "Coupon",
                                        hintStyle: GoogleFonts.ubuntu(
                                            color: Colors.grey[400],
                                            fontSize: 16),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                            width: 1,
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                            width: 1,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Config.white,
                                            width: 1,
                                          ),
                                        ),
                                        focusColor: Config.white,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Config.white,
                                            width: 1,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Config.white,
                                            width: 1,
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          CupertinoIcons.percent,
                                          color: Colors.grey[350],
                                        ),
                                        suffixIcon: ElevatedButton(
                                          onPressed: () {
                                            checkCoupon();
                                          },
                                          child: Text("Check"),
                                          style: ElevatedButton.styleFrom(
                                              shadowColor: Config.color_1,
                                              primary: Config.color_1,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        15),
                                              ),
                                              fixedSize: Size(80, 30)),
                                        ).paddingAll(5),
                                      ),
                                    )),
                              ],
                            ).paddingOnly(left: 20),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Order info",
                              style: GoogleFonts.ubuntu(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ).paddingOnly(top: 10, bottom: 20, left: 20),
                            Row(
                              children: [
                                Text("Sub Total",
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                                Spacer(),
                                Text("${cart.getSubPrice()} MAD",
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400))
                              ],
                            ).paddingOnly(left: 20, bottom: 10, right: 20),
                            Row(
                              children: [
                                Text("Delivery cost",
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                                Spacer(),
                                Text("${market.deliveryCost} MAD",
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400))
                              ],
                            ).paddingOnly(left: 20, bottom: 10, right: 20),
                            if (couponChecked)
                              Row(
                                children: [
                                  Text("Discount",
                                      style: GoogleFonts.ubuntu(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400)),
                                  Spacer(),
                                  Text("$discout MAD",
                                      style: GoogleFonts.ubuntu(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400))
                                ],
                              ).paddingOnly(left: 20, bottom: 10, right: 20),
                            Row(
                              children: [
                                Text("Total",
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                                Spacer(),
                                Text(
                                    "${double.parse(cart.getFinalPrice(context))} MAD",
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500))
                              ],
                            ).paddingOnly(left: 20, bottom: 10, right: 20),
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
                                .paddingOnly(bottom: 100),
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
                color: Colors.white,
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
                      "Proced to checkout",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ))
            : null);
  }

  
}
