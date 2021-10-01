import 'dart:io';
import 'package:daeem/configs/notification_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class PushNotificationService {
  final FirebaseMessaging _fcm;

  PushNotificationService(this._fcm);

  Future initialize() async {
    if (Platform.isIOS) {
      _fcm.requestPermission();
    }
    //String? token = await _fcm.getToken();
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if(value!=null){
         notifyManager.showNotification(int.tryParse(value.messageId!) ?? 0,value.notification!.title!, value.notification!.body!);
      }
    }
     
      
    );
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true,badge: true,sound: true);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {

      notifyManager.showNotification(int.tryParse(message.messageId!)??0,message.notification!.title!, message.notification!.body!);
    });
    
    FirebaseMessaging.onMessage.listen((message) {
      print(message.notification!.body);
      notifyManager.showNotification(int.tryParse(message.messageId!)??0,message.notification!.title!, message.notification!.body!);
    });
  }
}
