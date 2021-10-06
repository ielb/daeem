import 'dart:convert';

import 'package:daeem/models/client.dart';
import 'package:daeem/provider/base_provider.dart';
import 'package:daeem/services/client_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class ClientProvider extends BaseProvider {
  var _service = ClientService();
  Client? _client;
  Client? get client => _client; 
  void setClient(Client val) {
    _client = val;
    setNotificationToken();
    notifyListeners();
  }

  void setNotificationToken() async {    
     var token = await  FirebaseMessaging.instance.getToken();
    http.Response? response = await _service.token(_client!.id, token);
    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == "success") {
        _client!.token = token;
      }
    }
    notifyListeners();
  }

  Future<void> updateInfo(String name, String email) async {
    _client!.name = name;
    _client!.email = email;
    http.Response? response = await _service.editClientInfo(_client!);
    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == "success") {
        return;
      }
    }
    notifyListeners();
  }

  Future<void> changePassword(String current, String newPassword) async {
    http.Response? response =
        await _service.changePassword(_client!.id, newPassword);
    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      if (data['status'] == "success") {
        return;
      }
    }
    notifyListeners();
  }

  clear() {
    _client = null;
    notifyListeners();
  }
}
