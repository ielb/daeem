import 'package:daeem/models/address.dart';
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
    return null;
  }

  Future<http.Response?> updatePhone(id, phone) async {
    try {
      return await api
          .httpPost('client/phone', {'client_id': id, 'phone': phone});
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<http.Response?> updateAddress(Address address) async {
    try {
      return await api.httpPost('client/address', {
        'client_id': address.clientId,
        'address': address.address,
        'lat': address.lat ?? '',
        'lng': address.lng ?? '',
        'street_name': address.streetName,
        'house_number': address.houseNumber ?? '',
        'building_name': address.buildingName ?? '',
        'floor_door_number': address.floorDoorNumber ?? '',
        'code_postal': address.codePostal ?? '',
        'city': address.codePostal ?? ''
      });
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<http.Response?> getAddress(id) async {
    try {
      return await api.httpGet('client/$id/address');
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<http.Response?> resetPassword(id, password) async {
    try {
      return await api
          .httpPost('reset_password', {'client_id': id, 'password': password});
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<http.Response?> changePassword(id, oldP, newP) async {
    try {
      return await api.httpPost('client/password', {
        'client_id': id,
        'old_password': oldP,
        'new_password': newP,
      });
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<http.Response?> order(data) async {
    try {
      return await api.httpPost('order', {
        'data': data,
      });
    } catch (e) {
      print(e);
    }
    return null;
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
    return null;
  }

  Future<http.Response?> refund(String id, int orderId, String reason) async {
    try {
      print(id);
      print(orderId);
      print(reason);
      return await api.httpPost('order/refund', {
        'client_id': id.toString(),
        'order_id': orderId.toString(),
        'reason': reason.toString(),
      });
    } catch (e) {
      print(e);
    }
    return null;
  }
}
