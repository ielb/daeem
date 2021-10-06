import 'package:daeem/models/client.dart';
import 'package:daeem/services/base_api.dart';
import 'package:http/http.dart' as http;

class ClientService extends BaseApi {
  Future<http.Response?> editClientInfo(Client client) async {
    try {
      return await api.httpPost('edit_client_info',
          {'client_id': client.id, 'name': client.name, 'email': client.email});
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response?> updatePhone(Client client) async {
    try {
      return await api.httpPost('edit_client_info',
          {'client_id': client.id, 'name': client.name, 'email': client.email});
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response?> updateAddress(Client client) async {
    try {
      return await api.httpPost('edit_client_info',
          {'client_id': client.id, 'name': client.name, 'email': client.email});
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response?> changePassword(id, newP) async {
    try {
      return await api.httpPost('edit_client_info', {
        'client_id': id,
        'password': newP,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response?> token(id, token) async {
    try {
      return await api.httpPost('client/token', {
        'client_id': id,
        'token': token,
      });
    } catch (e) {
      print(e);
    }
  }
}
