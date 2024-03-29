import 'dart:async';
import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';

class Setup extends StatefulWidget {
  const Setup({Key? key}) : super(key: key);

  @override
  _SetupState createState() => _SetupState();
}

class _SetupState extends State<Setup> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Timer(
        Duration(microseconds: 50),
        () => Navigator.pushReplacement(
            context, CupertinoPageRoute(builder: (context) => Splash())));
    });
    super.initState();
  }

 

  @override
  void didChangeDependencies() {
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
      
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          Config.logo,
          width: MediaQuery.of(context).size.width * 0.5,
      ),
      ),
    );
  }
}
