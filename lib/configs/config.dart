import 'package:daeem/screens/client/add_address.dart';
import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';

class Config {
  static const background = "assets/background.png";
  static String logo = "assets/logo.png";
  static const delivery_address = "assets/delivery_address.gif";
  static Color color_1 = Color(0xff3091BE);
  static Color color_2 = Color(0xff27A6C7);
  static Color darkBlue = Color(0xff173A60);
  static Color white = Color(0xffffffff);
  static Color black = Color(0xff393939);
  static Color yellow = Color(0xffE6DA2A);
  static Color lightGray = Color(0xffF3F3F3);
  static const ontheway = "assets/ontheway.png";
  static const arrived = "assets/order_arrived.png";
  static const auth_background = "assets/back.jpg";
  static const shopping_cart = "assets/shopping_cart.png";
  static const confirmation = "assets/confirmation.png";
  static const password = "assets/password.png";
  static const notification = "assets/notification.png";

  static const appStoreUrl = "";
  static const playStoreUrl = "";
  static Widget google = Image.asset(
    "assets/Google.png",
    height: 30,
    width: 30,
  );
  static Widget facebook = Image.asset(
    "assets/Facebook.png",
    height: 30,
    width: 30,
  );
  static Widget empty = Image.asset(
    "assets/Empty.png",
    height: 290,
  );

  static Widget closed = Image.asset(
    "assets/closed.png",
    height: 35,
    width: 35,
  );
  static Widget emailSent({double height = 130, double width = 130}) =>
      Image.asset(
        "assets/email_sent.png",
        height: height,
        width: width,
      );

  static const margane = "assets/market_4.jpg";
  static const logo_white = "assets/logo_v.png";
  static bool isEmail(String email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(email);
  }

  static bool isPassword(String password) {
    bool isPass = password.length >= 8 ? true : false;

    return isPass;
  }

  static bool pwdValidator(String value) {
    if (value.length < 8) {
      return false;
    } else {
      return true;
    }
  }

  static String placeHolder = "assets/placeholder.png";

  static Map<String, dynamic> getStatus(int id, {String? date}) {
    List<Map<String, dynamic>> status = [
      {'id': 1, 'name': "Created", 'color': "info"},
      {'id': 2, 'name': "Accepted", 'color': "success"},
      {'id': 3, 'name': "Assigned", 'color': "primary"},
      {'id': 4, 'name': "Prepared", 'color': "info"},
      {'id': 5, 'name': "Delivered", 'color': "success"},
      {'id': 6, 'name': "Rejected", 'color': "danger"},
      {'id': 7, 'name': "Rejected", 'color': "danger"},
      {'id': 8, 'name': "Accepted", 'color': "success"},
      {'id': 9, 'name': "Assigned", 'color': "primary"},
      {'id': 10, 'name': "Refunded", 'color': "danger"},
    ];
    var data = status.firstWhere((element) => element['id'] == id);
    if (date != null) data.addAll({'created_at': date});
    return data;
  }

  static Color getStatusColor(String color) {
    switch (color) {
      case "info":
        return Colors.blue.shade700;
      case "success":
        return Color(0xff40AA45);
      case "primary":
        return color_2;
      case "danger":
        return Colors.red;
      default:
        return color_2;
    }
  }

  static Color getStatusSubColor(String color) {
    switch (color) {
      case "info":
        return Colors.blue.shade50;
      case "success":
        return Color(0xffD6EDD7);
      case "primary":
        return Color(0xffEBF7FA);
      case "danger":
        return Colors.red.shade50;
      default:
        return Color(0xffEBF7FA);
    }
  }

  static loading(BuildContext context) => showDialog(
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()));

  static bottomSheet(
    BuildContext context,
  ) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(15)),
            child: Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * .75,
              width: MediaQuery.of(context).size.width * .8,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  FadeInImage(
                      height: 250,
                      width: 250,
                      placeholder: AssetImage("assets/placeholder.png"),
                      image: AssetImage(
                        Config.delivery_address,
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Please add an address to see all stores near you",
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style:
                        GoogleFonts.ubuntu(fontSize: 20, color: Colors.black),
                  ),
                  Spacer(),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AddressPage.id);
                    },
                    height: 50,
                    elevation: 0,
                    splashColor: Config.color_1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Config.color_2,
                    child: Center(
                      child: Text(
                        "Add address",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
