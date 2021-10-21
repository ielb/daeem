import 'package:daeem/models/coupon.dart';
import 'package:daeem/models/item.dart';
import 'package:daeem/provider/cart_provider.dart';
import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/provider/market_provider.dart';
import 'package:daeem/screens/confirmed_screen.dart';
import 'package:daeem/screens/map_screen.dart';
import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class CheckoutPage extends StatefulWidget {
  static const id = "checkout";

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  ScrollController controller = ScrollController();
  late TextEditingController _controller ;
  bool called = false;
  late MarketProvider market;
  late CartProvider cart;
  String discout = '';
  @override
  void didChangeDependencies() {
    if (!called) {
      cart = Provider.of<CartProvider>(context, listen: false);
      market = Provider.of<MarketProvider>(context, listen: false);
      _controller = TextEditingController();
    }
    super.didChangeDependencies();
  }

  addToCart(Item item, BuildContext context) {
    cart.addToBasket(item);
  }

  removeFromCart(Item item, BuildContext context) {
    cart.removeFromBasket(item);
  }

  checkout() {
    cart.clearCart();
    Navigator.pushReplacementNamed(context, ConfirmedPage.id);
  }

  checkCoupon()async {
    showDialog(context: context,builder : (context) =>  CircularProgressIndicator(color: Config.color_2,).center());
    Coupon? coupon =  await market.checkCoupon(_controller.text);
    if(coupon == null) {

    }else{
       setState(() {
         couponChecked = true;
         discout = coupon.discount_price??'';
         Navigator.pop(context);
       });
    }
  }

  var address = true;
  var couponChecked = false;

  @override
  Widget build(BuildContext context) {
    var client = Provider.of<ClientProvider>(context, listen: false);
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          color: Config.black,
          iconSize: 26,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Checkout",
          textAlign: TextAlign.center,
          style: GoogleFonts.ubuntu(
              fontSize: 24, fontWeight: FontWeight.w400, color: Colors.black),
        ),
      ),
      body: market.isLoading
          ? Loading()
          : Container(
              height: screenSize(context).height,
              width: screenSize(context).width,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                controller: controller,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Delivery details",
                      style: GoogleFonts.ubuntu(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ).paddingOnly(top: 10, bottom: 20, left: 20),
                    Container(
                            height: 60,
                            width: screenSize(context).width * .9,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                    color: Config.color_1.withOpacity(0.5),
                                    width: 2),
                                borderRadius: BorderRadius.circular(15)),
                            child: client.client?.address == null
                                ? ListTile(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, MapScreen.id);
                                    },
                                    leading: Icon(
                                      CupertinoIcons.location,
                                      color: Colors.black,
                                      size: 26,
                                    ),
                                    horizontalTitleGap: 0,
                                    title: Text(
                                      "Address",
                                      style: GoogleFonts.ubuntu(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                    trailing: Icon(
                                      CupertinoIcons.chevron_down,
                                      size: 20,
                                    ),
                                  )
                                : ListTile(
                                    onTap: () {},
                                    leading: Icon(
                                      CupertinoIcons.location,
                                      color: Colors.black,
                                      size: 26,
                                    ),
                                    horizontalTitleGap: 0,
                                    title: Text(
                                      "${client.client!.address?.streetName}",
                                      style: GoogleFonts.ubuntu(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                    trailing: Icon(
                                      CupertinoIcons.chevron_right,
                                      size: 20,
                                    ),
                                  ))
                        .center()
                        .paddingOnly(top: 10),
                    Container(
                        height: 60,
                        width: screenSize(context).width * .9,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                                color: Config.color_1.withOpacity(0.5),
                                width: 2),
                            borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          onTap: () {},
                          isThreeLine: true,
                          leading: Icon(
                            CupertinoIcons.clock,
                            color: Colors.black,
                            size: 26,
                          ),
                          horizontalTitleGap: 0,
                          title: Text(
                            "ASAP",
                            style: GoogleFonts.ubuntu(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            "30-45 min",
                            style: GoogleFonts.ubuntu(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                          trailing: Icon(
                            CupertinoIcons.chevron_down,
                            size: 20,
                          ),
                        )).center().paddingOnly(top: 10),
                    Container(
                        height: 60,
                        width: screenSize(context).width * .9,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                                color: Config.color_1.withOpacity(0.5),
                                width: 2),
                            borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          onTap: () {},
                          leading: Icon(
                            CupertinoIcons.phone,
                            color: Colors.black,
                            size: 26,
                          ),
                          horizontalTitleGap: 0,
                          title: Text(
                            client.client?.phone ?? '',
                            style: GoogleFonts.ubuntu(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                          trailing: Icon(
                            CupertinoIcons.chevron_right,
                            size: 20,
                          ),
                        )).center().paddingOnly(top: 10),
                    SizedBox(
                      height: 20,
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
                                    color: Colors.grey[400], fontSize: 16),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 1,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Config.white,
                                    width: 1,
                                  ),
                                ),
                                focusColor: Config.white,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Config.white,
                                    width: 1,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
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
                                            new BorderRadius.circular(15),
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
                                fontSize: 16, fontWeight: FontWeight.w400)),
                        Spacer(),
                        Text("${cart.getFinalPrice()} MAD",
                            style: GoogleFonts.ubuntu(
                                fontSize: 16, fontWeight: FontWeight.w400))
                      ],
                    ).paddingOnly(left: 20, bottom: 10, right: 20),
                    Row(
                      children: [
                        Text("Delivery cost",
                            style: GoogleFonts.ubuntu(
                                fontSize: 16, fontWeight: FontWeight.w400)),
                        Spacer(),
                        Text("${market.deliveryCost} MAD",
                            style: GoogleFonts.ubuntu(
                                fontSize: 16, fontWeight: FontWeight.w400))
                      ],
                    ).paddingOnly(left: 20, bottom: 10, right: 20),
                    if (couponChecked)
                      Row(
                        children: [
                          Text("Discount",
                              style: GoogleFonts.ubuntu(
                                  fontSize: 16, fontWeight: FontWeight.w400)),
                          Spacer(),
                          Text("$discout MAD",
                              style: GoogleFonts.ubuntu(
                                  fontSize: 16, fontWeight: FontWeight.w400))
                        ],
                      ).paddingOnly(left: 20, bottom: 10, right: 20),
                    Row(
                      children: [
                        Text("Total",
                            style: GoogleFonts.ubuntu(
                                fontSize: 16, fontWeight: FontWeight.w400)),
                        Spacer(),
                        Text(
                            "${double.parse(cart.getFinalPrice()) + market.deliveryCost} MAD",
                            style: GoogleFonts.ubuntu(
                                fontSize: 17, fontWeight: FontWeight.w500))
                      ],
                    ).paddingOnly(left: 20, bottom: 10, right: 20),
                    ElevatedButton(
                      onPressed: () {
                        checkout();
                      },
                      child: Text(
                        "Checkout ( ${double.parse(cart.getFinalPrice()) + market.deliveryCost} MAD )",
                        style: GoogleFonts.ubuntu(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                      style: ElevatedButton.styleFrom(
                          shadowColor: Config.color_1,
                          primary: Config.color_1,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(15),
                          ),
                          fixedSize: Size(screenSize(context).width * .9, 50)),
                    )
                        .align(alignment: Alignment.bottomCenter)
                        .paddingOnly(top: 20, bottom: 20),
                  ],
                ),
              ),
            ),
    );
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
                      onPressed: () => removeFromCart(item, context),
                      icon: Icon(CupertinoIcons.minus),
                      color: Colors.redAccent,
                    ).center()),
                SizedBox(
                  width: 10,
                ),
                Text(" ${item.quantity}x"),
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
                      onPressed: () => addToCart(item, context),
                      icon: Icon(CupertinoIcons.add),
                      color: Config.color_2,
                      iconSize: 18,
                    ).center())
              ],
            ),
          )),
    );
  }
}
