import 'package:http/http.dart' as http;
import 'package:daeem/services/base_api.dart';

class OrderService extends BaseApi {

 Future<http.Response?> getClientOrders(String id ) async {
    try {
      return await api.httpGet('client/$id/orders');
    } catch (e) {
      print(e);
    }
  }
  Future<http.Response?> getOrderStatus(String id ) async {
    try {
      return await api.httpGet('order/$id');
    } catch (e) {
      print(e);
    }
  }
  // ignore: non_constant_identifier_names
  Future<http.Response?> requestRefund(String order_id,String client_id,String reason ) async {
    try {
      return await api.httpPost('order/refund',{
        'order_id':order_id,
        'client_id':client_id,
        'reason':reason
      });
    } catch (e) {
      print(e);
    }
  }
  Future<http.Response?> getOrderHistory(String id ) async {
    try {
      return await api.httpGet('order/$id/statuses');
    } catch (e) {
      print(e);
    }
  }


}

