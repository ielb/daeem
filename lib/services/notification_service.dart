import 'dart:io';
import 'package:daeem/configs/notification_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm;

  PushNotificationService(this._fcm);

  Future initialize() async {
    if (Platform.isIOS) {
      _fcm.requestPermission(
          alert: true,
          announcement: true,
          badge: true,
          criticalAlert: true,
          sound: true);
    }

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print(" data ${message?.data['title']}");
      if (message != null) {
        notifyManager.showNotification(
            0, message.data['title'], message.data['body']);
      }
    });
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(" data ${message.data['title']}");
      notifyManager.showNotification(
          1, message.data['title'], message.data['body']);
    });

    FirebaseMessaging.onMessage.listen((message) {
      print(" data ${message.data['title']}");
      notifyManager.showNotification(
          2, message.data['title'], message.data['body']);
    });
  }
}
