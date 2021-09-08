import 'package:daeem/configs/config.dart';
import 'package:daeem/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:daeem/services/services.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardering extends StatefulWidget {
  static const id = "boarding";

  @override
  _OnBoarderingState createState() => _OnBoarderingState();
}

class _OnBoarderingState extends State<OnBoardering> {
  List<PageViewModel> pages = [
    PageViewModel(
      title: "With Daeem",
      body: "Explore  top super market in your city",
      image: Center(
        child: Image.asset(Config.shopping_cart, height: 175.0),
      ),
    ),
    PageViewModel(
      title: "Delivery on the way",
      body: "Get your order by speed delivery",
      image: Image.asset(Config.ontheway, height: 175.0)
          .paddingOnly(top: 50)
          .center(),
    ),
    PageViewModel(
      title: "Delivery Arrived",
      body: "Order is arrived at your Place",
      image: Center(
        child: Image.asset(Config.arrived, height: 175.0),
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body: IntroductionScreen(
          globalBackgroundColor: Config.white,
          pages: pages,
          showNextButton: true,
          showSkipButton: true,
          showDoneButton: true,
          next: Text("Next", style: TextStyle(fontWeight: FontWeight.w600)),
          onDone: () {
            Navigator.pushReplacement(
                context, CupertinoPageRoute(builder: (context) => Login()));
          },
          onSkip: () {
            Navigator.pushReplacement(
                context, CupertinoPageRoute(builder: (context) => Login()));
          },
          skip: Text("skip", style: TextStyle(fontWeight: FontWeight.w600)),
          done: Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
        )));
  }
}
