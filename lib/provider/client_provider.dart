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
  String? _sms;
  void setClient(Client val) {
    _client = val;
    setNotificationToken();
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

  refundOrder(int orderId, String reason) async {
    print(reason);
    http.Response? response =
        await _service.refund(_client!.id!, orderId, reason);
        print(response?.body);
    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      if (data['status'] == "success") {
        return true;
      
      }
      else {
        return false;
      }
    }else {
      return false;
    }
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

  Future<bool> resetPassword(Client currentClient, String password) async {
    http.Response? response =
        await _service.resetPassword(currentClient.id, password);

    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == "success") {
        return true;
      } else {
        return false;
      }
    }
    notifyListeners();
    return false;
  }

  Future<bool?> changePassword(String oldPassword, String newPassword) async {
    http.Response? response =
        await _service.changePassword(_client?.id, oldPassword, newPassword);

    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == "success") {
        return true;
      } else {
        return false;
      }
    }
    return null;
  }

  changePhone({required String smsCode, required String phone}) async {
    if (smsCode == _sms) {
      http.Response? response = await _service.updatePhone(_client!.id, phone);
      if (response != null && response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == "success") {
          print(data);
          _client!.phone = phone;
          notifyListeners();
          return true;
        } else
          return false;
      }
      notifyListeners();
      return false;
    } else
      notifyListeners();
    return false;
  }

  updateAddress(Address address) async {
    http.Response? response = await _service.updateAddress(address);

    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data['data']);
      setClientAddress(Address.fromMap(data['data']));
      print(_client!.address?.id);
      notifyListeners();
    }
  }

  getClientAddress(Client client) async {
    setBusy(true);
    http.Response? response = await _service.getAddress(client.id);
    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == "success") {
        _client!.address = null;
        _client!.address = Address.fromMap(data['data']);
        notifyListeners();
      }
    }
  }

  setClientAddress(Address address) {
    _client!.address = null;
    _client!.address = address;
    notifyListeners();
  }

  verifyClientPhoneNumber(String phone) {
    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+212${phone.length == 9 ? phone : phone.substring(1)}",
        verificationCompleted: (phoneAuthCredential) {
          _sms = phoneAuthCredential.smsCode;
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
