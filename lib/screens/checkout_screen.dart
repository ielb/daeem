// ignore_for_file: unused_import

import 'package:daeem/models/coupon.dart';
import 'package:daeem/models/item.dart';
import 'package:daeem/provider/cart_provider.dart';
import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/provider/market_provider.dart';
import 'package:daeem/screens/client/add_address.dart';
import 'package:daeem/screens/client/change_phone.dart';
import 'package:daeem/screens/confirmed_screen.dart';
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

  bool called = false;
  late StoreProvider market;
  late CartProvider cart;

  DateTime? deleveryDate;
  @override
  void didChangeDependencies() {
    if (!called) {
      cart = Provider.of<CartProvider>(context);
      market = Provider.of<StoreProvider>(context);

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

  var address = true;

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
                                      "${client.client!.address?.address} ",
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
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
                            Navigator.pushNamed(context, ChangePhone.id,
                                arguments: 1);
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
                              color: Colors.black,
                            ),
                          ),
                          trailing: Icon(
                            CupertinoIcons.chevron_right,
                            size: 20,
                          ),
                        )).center().paddingOnly(top: 10),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: client.client!.address != null ||
              client.client!.phone != null
          ? Container(
              height: 100,
              color: Colors.transparent,
              child: ElevatedButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) => Dialog(
                          child: Container(
                              padding: EdgeInsets.only(top:20,bottom: 10,left: 20,right: 20),
                              height: screenSize(context).height * .5,
                              child: Column(children: [
                                Image(
                                  image: AssetImage(
                                    Config.delivery_address,
                                  ),
                                  height: 150,
                                ),
                                Text(
                                  "Are you sure you want to order?",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Spacer(),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: GoogleFonts.ubuntu(
                                              fontSize: 18, color: Colors.red),
                                        ),
                                      ),
                                      Spacer(),
                                      TextButton(
                                        onPressed: () async {
                                          showDialog(
                                              context: context,
                                              builder: (conetext) =>
                                                  CircularProgressIndicator()
                                                      .center());
                                          var result = await cart.checkout(
                                              context,
                                              client.client!,
                                              market.currentMarket!.id
                                                  .toString(),
                                              deleveryDate);
                                          if (result) {
                                            Navigator.pushReplacementNamed(
                                                context, ConfirmedPage.id);
                                          } else {
                                            showTopSnackBar(
                                                context,
                                                CustomSnackBar.error(
                                                    message:
                                                        "Somthing went wrong please try again"));
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Text("Confirm", style: GoogleFonts.ubuntu(
                                              fontSize: 18, color: Config.color_2),),
                                      )
                                    ]
                                ),
                              ]
                            )
                          )
                      )
                  );
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
                    fixedSize: Size(screenSize(context).width * .9, 50)),
              )
                  .align(alignment: Alignment.bottomCenter)
                  .paddingOnly(top: 20, bottom: 20),
            )
          : Container(
              height: 100,
              color: Colors.transparent,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Checkout ( ${double.parse(cart.getFinalPrice(context))} MAD )",
                  style: GoogleFonts.ubuntu(fontSize: 18, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
                style: ElevatedButton.styleFrom(
                    shadowColor: Colors.grey.shade400,
                    primary: Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15),
                    ),
                    fixedSize: Size(screenSize(context).width * .9, 50)),
              )
                  .align(alignment: Alignment.bottomCenter)
                  .paddingOnly(top: 20, bottom: 20),
            ),
    );
  }
}
