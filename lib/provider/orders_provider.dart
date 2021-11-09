import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:daeem/models/order.dart';
import 'package:daeem/provider/base_provider.dart';
import 'package:daeem/services/orders_service.dart';

class OrdersProvider extends BaseProvider {
  OrderService _orderService = OrderService();
  List<Order> _orders = List.empty(growable: true);
  List<Order> get orders => _orders;

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  void removeOrder(Order order) {
    _orders.remove(order);
    notifyListeners();
  }

  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }

  Future<bool> getOrders({required String clientId}) async {
    if(_orders.isNotEmpty) _orders.clear();
    http.Response? response = await _orderService.getClientOrders(clientId);
    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == "success") {
        data = data['data'].first; 
        _orders = (data as List).map((i) => Order.fromMap(i)).toList();
       _orders = _orders.reversed.toList();
       notifyListeners();
       return true;
      }else 
      notifyListeners();
        return false;
       
    }
    else
     notifyListeners();
      return false;
  }
}
