import 'dart:async';
import 'package:daeem/configs/notification_manager.dart';
import 'package:daeem/provider/auth_provider.dart';
import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/screens/connection.dart';
import 'package:daeem/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:daeem/services/services.dart';
import "package:provider/provider.dart";
import "package:simple_connection_checker/simple_connection_checker.dart";

class Splash extends StatefulWidget {
  static const id = "/splash";

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Timer? _timer;
  late PushNotificationService _notificationService;
  StreamSubscription? subscription;
  late AuthProvider auth ;
  late ClientProvider client;
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async { 
      auth =  Provider.of<AuthProvider>(context, listen: false);
      client = Provider.of<ClientProvider>(context, listen: false);
        notifyManager.setOnNotificationClick(onNotificationClick);
        notifyManager.setOnNotificationReceive(onNotificationReceive);
        _notificationService =
            PushNotificationService(FirebaseMessaging.instance);
        _notificationService.initialize();

      _timer = new Timer(const Duration(milliseconds: 2000), () {
     
        SimpleConnectionChecker _simpleConnectionChecker =
            SimpleConnectionChecker()
              ..setLookUpAddress(
                  'pub.dev'); //Optional method to pass the lookup string
        subscription =
            _simpleConnectionChecker.onConnectionChange.listen((connected) {
          if (connected) {
            _getAuthClient();
          } else {
            Navigator.pushReplacementNamed(context, LostConnection.id);
          }
        });
      });
    });

    super.initState();
  }

  onNotificationClick(RecieveNotification notification) {
    print("Notification Received : ${notification.id}");
  }

  onNotificationReceive(String payload) {
    print('Payload $payload');
  }

  void _getAuthClient() async {
    print("test");
    String? id = await Prefs.instance.getClient();
    bool? isAut = await Prefs.instance.getAuth();

    if (id != null && isAut != null) {
      bool result = await auth.getAuthenticatedClient(
        id,
      );

      if (result) {
        client.setClient(auth.client!);
        client.getClientAddress(auth.client!);
        Navigator.pushReplacementNamed(context, Home.id);
      } else {
        _skip();
      }
    } else {
      _skip();
    }
  }

  void _skip() async {
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
    subscription?.cancel();
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
