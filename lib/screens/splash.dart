import 'dart:async';
import 'package:daeem/provider/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:daeem/services/services.dart';
import "package:provider/provider.dart";

class Splash extends StatefulWidget {
  static const id = "/splash";

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Timer? _timer;
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_)=>_skip());


    _timer = new Timer(const Duration(milliseconds: 2000), () {
      Navigator.pushReplacementNamed(context,OnBoardering.id);
    });
    super.initState();
  }
    _skip() async{
      final auth = Provider.of<AuthProvider>(context, listen: false);
      bool isOnBoardingSkipped = await auth.getOnBoardingSkipped() ?? false;
      if(isOnBoardingSkipped) {
        Navigator.pushReplacementNamed(context, Login.id);
      }
    }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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

