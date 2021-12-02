import 'package:daeem/database/database.dart';
import 'package:daeem/models/notification.dart';
import 'package:daeem/provider/base_provider.dart';

class NotificationProvider extends BaseProvider {
  List<Notification> _notifications = List.empty(growable: true);
  List<Notification> get notifications => _notifications;
  DatabaseHandler _db = DatabaseHandler();

  Future<void> getNotifications() async {
    _db.getNotifications().then((value) {
      if (value != null) {
        _notifications = value;
        notifyListeners();
      }
    });
    notifyListeners();
  }

  Future<void> addNotification(Notification notification) async {

   var result = await _db.addNotification(notification);
   if(result){
     if(!_notifications.contains((element) => notification==element))
      _notifications.add(notification);
      notifyListeners();
   }
  }

  void clearNotifications() {
    if(_notifications.isNotEmpty){
   
     _db.clearNotifications();
    _notifications.clear();
    notifyListeners();
    }
  }
}
