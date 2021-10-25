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
    
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print(message?.data);
      if(message!=null){
         notifyManager.showNotification(0,message.data['title'], message.data['body']);
      }
    }
     
      
    );
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true,badge: true,sound: true);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message.data);
      notifyManager.showNotification(0,message.data['title'], message.data['body']);
    });
    
    FirebaseMessaging.onMessage.listen((message) {
      notifyManager.showNotification(0,message.data['title'], message.data['body']);
    });
  }
}
