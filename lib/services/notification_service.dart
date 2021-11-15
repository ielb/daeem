import 'dart:io';
import 'package:daeem/configs/notification_manager.dart';
import 'package:daeem/provider/notifiation_provider.dart';
import 'package:daeem/services/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:daeem/models/notification.dart' as notif; 

class PushNotificationService {
  final FirebaseMessaging _fcm;

  PushNotificationService(this._fcm);

  Future initialize(BuildContext context) async {
    var _notificationProvider = Provider.of<NotificationProvider>(context,listen: false);
    if (Platform.isIOS) {
      _fcm.requestPermission(
          alert: true,
          announcement: true,
          badge: true,
          criticalAlert: true,
          sound: true);
   }

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print("Init");
     
      if (message != null) {
        _notificationProvider.addNotification(notif.Notification.fromMap(message.data));
        notifyManager.showNotification(
            0, message.data['title'], message.data['body']);
      }
    });
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("Opend");
      _notificationProvider.addNotification(notif.Notification.fromMap(message.data));
      notifyManager.showNotification(
          1, message.data['title'], message.data['body']);
    });

    FirebaseMessaging.onMessage.listen((message) {
      print("Message");
       _notificationProvider.addNotification(notif.Notification.fromMap(message.data));
      notifyManager.showNotification(
          2, message.data['title'], message.data['body']);
    });
  }
}
