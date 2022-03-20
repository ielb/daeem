import 'package:http/http.dart' as http;
import 'package:daeem/services/base_api.dart';

class OrderService extends BaseApi {
  Future<http.Response?> getClientOrders(String id) async {
    try {
      return await api.httpGet('client/$id/orders');
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<http.Response?> getOrderStatus(String id) async {
    try {
      return await api.httpGet('order/$id');
    } catch (e) {
      print(e);
    }
    return null;
  }

  // ignore: non_constant_identifier_names
  Future<http.Response?> requestRefund(
      String orderId, String clientId, String reason) async {
    try {
      return await api.httpPost('order/refund',
          {'order_id': orderId, 'client_id': clientId, 'reason': reason});
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<http.Response?> getOrderHistory(String id) async {
    try {
      return await api.httpGet('order/$id/statuses');
    } catch (e) {
      print(e);
    }
    return null;
  }
}
