import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Config {
  static const background = "assets/background.png";
  static String logo = "assets/logo.png";
  static Color color_1 = Color(0xff3091BE);
  static Color color_2 = Color(0xff27A6C7);
  static Color darkBlue = Color(0xff173A60);
  static Color white = Color(0xffffffff);
  static Color black = Color(0xff393939);
  static Color yellow = Color(0xffE6DA2A);
  static Color lightGray = Color(0xffF3F3F3);
  static const ontheway = "assets/ontheway.png";
  static const arrived = "assets/order_arrived.png";
  static const auth_background = "assets/market.png";
  static const shopping_cart = "assets/shopping_cart.png";
  static Widget google = SvgPicture.asset("assets/Google.svg",height: 26,width: 26,);
  static Widget facebook = SvgPicture.asset("assets/Facebook.svg",height: 26,width: 26,);
  static Widget user = SvgPicture.asset("assets/user.svg",height: 26,width: 26,);
  static Widget shoppingBag = SvgPicture.asset("assets/shopping-bag.svg",height: 26,width: 26,);
  static Widget logout = SvgPicture.asset("assets/logout.svg",height: 26,width: 26,);
  static Widget rate = SvgPicture.asset("assets/rate.svg",height: 26,width: 26,);
  static Widget share = SvgPicture.asset("assets/share.svg",height: 26,width: 26,);
  static Widget notification = SvgPicture.asset("assets/notifications.svg",height: 26,width: 26,);
  static Widget question = SvgPicture.asset("assets/question.svg",height: 26,width: 26,);
  static Widget closed = SvgPicture.asset("assets/closed.svg",height: 35,width: 35,);
  static Widget emailSent = SvgPicture.asset("assets/email_sent.svg",height: 130,width: 130,);

  static const margane = "assets/market_4.jpg";
  static const logo_white ="assets/logo_v.png";
  static bool isEmail(String email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(email);
  }
  static bool isPassword(String password) {
    bool isPass = password.length >= 8 ? true :false ;

    return isPass;
  }


  static bool pwdValidator(String value) {
    if (value.length < 8) {
      return false;
    } else {
      return true;
    }
  }
}
