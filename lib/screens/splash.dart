import 'dart:async';
import 'package:daeem/configs/notification_manager.dart';
import 'package:daeem/provider/auth_provider.dart';
import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  late PushNotificationService _notificationService;
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
        // var  result  = await connection();
        // if(!result){
        //   Navigator.of(context).pushReplacementNamed('connection');
        // }

      _timer = new Timer(const Duration(milliseconds: 2000), () {
        _getAuthClient();
      });
    });

    notifyManager.setOnNotificationClick(onNotificationClick);
    notifyManager.setOnNotificationReceive(onNotificationReceive);
    _notificationService = PushNotificationService(FirebaseMessaging.instance);
    _notificationService.initialize();
    super.initState();
  }
//     connection()async{
//     try {
//   final result = await InternetAddress.lookup('app.daeem.ma');
//   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//     return true;
//   }else{
//      return false;
//   }
// } on SocketException catch (_) {
//   print('not connected');
// }
//  return false;
//   }

  onNotificationClick(RecieveNotification notification) {
    print("Notification Received : ${notification.id}");
  }

  onNotificationReceive(String payload) {
    print('Payload $payload');
  }

  void _getAuthClient() async {
    print("test");
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final client = Provider.of<ClientProvider>(context, listen: false);
    String? id = await Prefs.instance.getClient();
    bool? isAut = await Prefs.instance.getAuth();

    if (id != null && isAut != null) {
      bool result = await auth.getAuthenticatedClient(
        id,
      );

      if (result) {
        client.setClient(auth.client!);
        Navigator.pushReplacementNamed(context, Home.id);
      } else {
        _skip();
      }
    } else {
      _skip();
    }
     
  }

  void _skip() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    bool? isOnBoardingSkipped = await auth.getOnBoardingSkipped();
    if (isOnBoardingSkipped != null && isOnBoardingSkipped) {
      Navigator.pushReplacementNamed(context, Login.id);
    } else {
      Navigator.pushReplacementNamed(context, OnBoardering.id);
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
