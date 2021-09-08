import 'dart:async';

import 'package:daeem/configs/config.dart';
import 'package:daeem/screens/onBoarding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:daeem/services/services.dart';

class Splash extends StatefulWidget {
  static const id = "/splash";

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1000), () {
      Navigator.pushReplacement(context,CupertinoPageRoute(builder: (context)=>OnBoardering()));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(
        AssetImage(
          Config.logo,
        ),
        context);
    precacheImage(
        AssetImage(
          Config.background,
        ),
        context);
    precacheImage(
        AssetImage(
          Config.shopping_cart,
        ),
        context);
    precacheImage(
        AssetImage(
          Config.ontheway,
        ),
        context);
    precacheImage(
        AssetImage(
          Config.arrived,
        ),
        context);
    precacheImage(
        AssetImage(
          Config.auth_background,
        ),
        context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: screenSize(context).height,
            width: screenSize(context).width,
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage(Config.background),
                fit: BoxFit.fitWidth,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Config.logo,
                ).paddingOnly(bottom: screenSize(context).height * .02),
                Text(
                  "Slogan Place",
                  style: GoogleFonts.ubuntu(
                      fontWeight: FontWeight.w300,
                      fontSize: 22,
                      color: Config.color_2,
                      letterSpacing: 7),
                ).center(),
                CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Config.color_1,
                ).paddingOnly(top: screenSize(context).height * .15)
              ],
            )));
  }
}
