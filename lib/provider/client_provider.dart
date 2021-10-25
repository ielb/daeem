import 'dart:convert';

import 'package:daeem/models/address.dart';
import 'package:daeem/models/client.dart';
import 'package:daeem/provider/base_provider.dart';
import 'package:daeem/services/client_service.dart';
import 'package:daeem/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class ClientProvider extends BaseProvider {
  var _service = ClientService();

  Client? _client;
  Client? get client => _client;
  String? sms;
  void setClient(Client val) {
    _client = val;
    setNotificationToken();
    notifyListeners();
  }

  void setNotificationToken() async {
    var token = await FirebaseMessaging.instance.getToken();
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
        notifyListeners();
        return;
      }
    }
    notifyListeners();
  }

  Future<String?> changePassword(String oldPassword, String newPassword) async {
    http.Response? response =
        await _service.changePassword(_client!.id, oldPassword, newPassword);

    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == "success") {
        return "The password has been changed";
      } else {
        return "Your current password is incorrect. Please try again";
      }
    }

    notifyListeners();
  }

  changePhone({required String smsCode, required String phone}) async {
    if (smsCode == sms) {
      http.Response? response = await _service.updatePhone(_client!.id, phone);
      if (response != null && response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == "success") {
          _client!.phone = phone;
          notifyListeners();
          return true;
        } else
          return false;
      }
      return false;
    } else
      return false;
  }

  updateAddress(Address address) async {
    http.Response? response = await _service.updateAddress(address);

    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == "success") {
        _client!.address = address;
        notifyListeners();
      }
    }
  }

  getClientAddress(Client client) async {
    http.Response? response = await _service.getAddress(client.id);
    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      if (data['status'] == "success") {
        _client!.address = Address.fromMap(data['data']);
        notifyListeners();
      }
    }
  }

  setClientAddress(Address address) {
    _client!.address = address;
    notifyListeners();
  }

  verifyClientPhoneNumber(String phone) {
    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (phoneAuthCredential) {
          sms = phoneAuthCredential.smsCode;
          notifyListeners();
        },
        verificationFailed: (error) {},
        codeSent: (text, _) {},
        codeAutoRetrievalTimeout: (code) {});
  }

  clear() {
    _client = null;
    notifyListeners();
  }
}
