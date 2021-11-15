


import 'package:daeem/models/notification.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
   Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    databaseExists(path);
    return openDatabase(
      join(path, 'notification.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE notification(id INTEGER,title TEXT ,body TEXT)",
        );
      },
      version: 1,
    );
  }


  Future<bool> addNotification(Notification notification) async {
    Database database = await initializeDB();
    if (database.isOpen) {
      int i = await database.insert('notification', notification.toMap());
      if (i > 0) return true;
    }
    return false;
  }

  clearNotifications() async {
    Database database = await initializeDB();
    if (database.isOpen) {
      int i = await database.delete('notification');
      if (i > 0) return true;
    }
    return false;}

  
  Future<List<Notification>?> getNotifications() async {
    Database database = await initializeDB();
    if (database.isOpen) {
      List<Map<String, Object?>> data = await database.query('notification');
      List<Notification> notifications = List.empty(growable: true);
      data.forEach((element) {
        notifications.add(Notification.fromMap(element));
      });
      return notifications;
    }
    return null;
  }
}