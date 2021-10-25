// ignore_for_file: unused_import

import 'package:daeem/models/coupon.dart';
import 'package:daeem/models/item.dart';
import 'package:daeem/provider/cart_provider.dart';
import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/provider/market_provider.dart';
import 'package:daeem/screens/client/add_address.dart';
import 'package:daeem/screens/client/change_phone.dart';
import 'package:daeem/screens/confirmed_screen.dart';
import 'package:daeem/screens/map_screen.dart';
import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CheckoutPage extends StatefulWidget {
  static const id = "checkout";

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  ScrollController controller = ScrollController();
  late TextEditingController _controller;
  bool called = false;
  late MarketProvider market;
  late CartProvider cart;
  String discout = '';
  DateTime? deleveryDate;
  @override
  void didChangeDependencies() {
    if (!called) {
      cart = Provider.of<CartProvider>(context, listen: false);
      market = Provider.of<MarketProvider>(context, listen: false);
      _controller = TextEditingController();
      setState(() {
        called = true;
      });
    }

    super.didChangeDependencies();
  }

  addToCart(Item item, BuildContext context) {
    cart.addToBasket(item);
  }

  removeFromCart(Item item, BuildContext context) {
    cart.removeFromBasket(item);
  }

  checkCoupon() async {
    FocusScope.of(context).requestFocus(FocusNode());
    showDialog(
        context: context,
        builder: (context) => CircularProgressIndicator(
              color: Config.color_2,
            ).center());
    Coupon? coupon = await cart.checkCoupon(_controller.text);
    if (coupon == null) {
      Navigator.pop(context);
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "The coupon is worng",
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

  var address = true;
  var couponChecked = false;

  getDeliveryTime() {
    showTopSnackBar(
      context,
      CustomSnackBar.info(
        message: "Please select date between 9:00 to 23:00",
      ),
    );
    DatePicker.showDateTimePicker(context,
        minTime: DateTime.now(),
        maxTime: DateTime.now().add(Duration(days: 5)), onChanged: (date) {
      if (date.hour < 9 || date.hour > 23)
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: "The selected date is not supported",
          ),
        );
    }, onConfirm: (comfirmedDate) {
      setState(() {
        deleveryDate = comfirmedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var client = Provider.of<ClientProvider>(context, listen: true);
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
                                          context, AddressPage.id);
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
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, AddressPage.id,
                                          arguments: "checkout");
                                    },
                                    leading: Icon(
                                      CupertinoIcons.location,
                                      color: Colors.black,
                                      size: 26,
                                    ),
                                    horizontalTitleGap: 0,
                                    title: Text(
                                      "${client.client!.address?.streetName}",
                                      style: GoogleFonts.ubuntu(
                                        fontSize: 18,
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
                          onTap: () {
                            getDeliveryTime();
                          },
                          isThreeLine: deleveryDate != null ? false : true,
                          leading: Icon(
                            CupertinoIcons.clock,
                            color: Colors.black,
                            size: 26,
                          ),
                          horizontalTitleGap: 0,
                          title: Text(
                            deleveryDate != null
                                ? "${DateFormat(DateFormat.MONTH_DAY).format(deleveryDate!)} at ${deleveryDate!.hour}:${deleveryDate!.minute}"
                                : "ASAP",
                            style: GoogleFonts.ubuntu(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: deleveryDate != null
                              ? null
                              : Text(
                                  "30-45 min",
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 14,
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
                          onTap: () {
                            Navigator.pushNamed(context, ChangePhone.id);
                          },
                          leading: Icon(
                            CupertinoIcons.phone,
                            color: Colors.black,
                            size: 26,
                          ),
                          horizontalTitleGap: 0,
                          title: Text(
                            client.client?.phone ?? '',
                            style: GoogleFonts.ubuntu(
                              fontSize: 18,
                              color: Colors.grey[700],
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
                        Text("${cart.getSubPrice()} MAD",
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
                        Text("${double.parse(cart.getFinalPrice(context))} MAD",
                            style: GoogleFonts.ubuntu(
                                fontSize: 17, fontWeight: FontWeight.w500))
                      ],
                    ).paddingOnly(left: 20, bottom: 10, right: 20),
                    client.client!.address != null &&
                            client.client!.phone != null
                        ? ElevatedButton(
                            onPressed: () async {
                              showDialog(context: context, builder: (context)=>CircularProgressIndicator(color: Config.color_1,).center());
                              var result =  await cart.checkout(
                                  context,
                                  client.client!,
                                  market.currentMarket!.id.toString(),
                                  deleveryDate);
                             if(result){
                                Navigator.pushReplacementNamed(context,ConfirmedPage.id);

                             }else{
                               showTopSnackBar(context, 
                                  CustomSnackBar.error(message: "Somthing went wrong please try again")
                               );
                               Navigator.pop(context);
                             }
                            },
                            child: Text(
                              "Checkout ( ${double.parse(cart.getFinalPrice(context))} MAD )",
                              style: GoogleFonts.ubuntu(fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ),
                            style: ElevatedButton.styleFrom(
                                shadowColor: Config.color_1,
                                primary: Config.color_1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(15),
                                ),
                                fixedSize:
                                    Size(screenSize(context).width * .9, 50)),
                          )
                            .align(alignment: Alignment.bottomCenter)
                            .paddingOnly(top: 20, bottom: 20)
                        : ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              "Checkout ( ${double.parse(cart.getFinalPrice(context))} MAD )",
                              style: GoogleFonts.ubuntu(
                                  fontSize: 18, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                            style: ElevatedButton.styleFrom(
                                shadowColor: Colors.grey.shade400,
                                primary: Colors.grey.shade400,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(15),
                                ),
                                fixedSize:
                                    Size(screenSize(context).width * .9, 50)),
                          )
                            .align(alignment: Alignment.bottomCenter)
                            .paddingOnly(top: 20, bottom: 20),
                  ],
                ),
              ),
            ),
    );
  }
}
