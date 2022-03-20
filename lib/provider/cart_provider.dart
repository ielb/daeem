import 'dart:async';
import 'dart:convert';
import 'package:daeem/models/coupon.dart';
import 'package:daeem/models/item.dart';
import 'package:daeem/models/product.dart';
import 'package:daeem/provider/base_provider.dart';
import 'package:daeem/provider/market_provider.dart';
import 'package:daeem/services/client_service.dart';
import 'package:daeem/services/store_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:daeem/models/client.dart' as cl;

class CartProvider extends BaseProvider {
  List<Item> _basket = List.empty(growable: true);
  List<Item> get basket => _basket;
  StoreService _storeService = StoreService();
  ClientService _clientService = ClientService();
  Coupon? coupon;

  DateTime? deliveryTime;

  setDeliveryTime(DateTime time) {
    deliveryTime = time;
    notifyListeners();
  }

  Future<Coupon?> checkCoupon(String data) async {
    Response? response = await _storeService.checkCoupon(data);
    if (response != null) {
      var data = jsonDecode(response.body);
      if (data["status"] == "success") {
        coupon = Coupon.fromJson(jsonEncode(data["data"]));
        return coupon;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  String getFinalPrice(BuildContext context) {
    double price = 0;
    if (coupon == null) {
      price = 0;
      _basket.forEach((element) {
        price = (double.tryParse(element.product.price!)! * element.quantity) +
            price;
      });
      var finalPrice = price +
          Provider.of<StoreProvider>(context, listen: false).deliveryCost;
      return finalPrice.toStringAsFixed(2);
    } else {
      price = 0;
      _basket.forEach((element) {
        price = (double.tryParse(element.product.price!)! * element.quantity) +
            price;
      });
      var finalPrice = (price +
              Provider.of<StoreProvider>(context, listen: false)
                  .deliveryCost) -
          double.parse(coupon!.discount_price!);
      return finalPrice.toStringAsFixed(2);
    }
  }

  Future<bool> checkout(BuildContext context, cl.Client client, String marketId,
      DateTime? deliveryTime) async {
    if (_basket.isEmpty) {
      print("empty");
      return false;
    } else {
      var list = List.empty(growable: true);
     
   _basket.forEach((element) {
     var data = {
       "id":element.product.id,
        "price":double.parse(element.product.price??'0'),
        "quantity":element.quantity,
        "variant":element.product.currentVariant?.id ?? '-1',
     };
     list.add(data);
   });



      var data = {
        'client_id': client.id,
        'store_id': marketId,
        'address_id': client.address!.id,
        'order_price': getFinalPrice(context),
        'delivery_price':
            Provider.of<StoreProvider>(context, listen: false).deliveryCost,
        'use_coupon': coupon != null ? 1 : 0,
        'price_after_coupon': getFinalPrice(context),
        'discount_price': coupon!=null ? coupon!.discount_price :0,
        'use_delivery_time': deliveryTime != null ? 1 : 0,
        'delivery_time': deliveryTime != null ? deliveryTime.toString() : "",
        'products': list
      };
      var result = jsonEncode(data);
      print(result);
      Response? response = await _clientService.order(result);
      print("response : ${response?.body}");
      if (response != null && response.statusCode == 200) {
        _basket.clear();
        return true;
      } else
        return false;
      
    }
  }

  bool addToBasket(Item item) {
    if (_basket.isEmpty) {
      _basket.add(item);
      notifyListeners();
      return true;
    } else {
      Item data = _basket.singleWhere(
          (element) => item.product.id == element.product.id,
          orElse: () => Item(product: Product()));
      if (data.product.id == null) {
        _basket.add(item);

        notifyListeners();
        return true;
      } else {
        int index = _basket.indexOf(data);
        data.quantity++;
        _basket[index] = data;
        notifyListeners();
        return false;
      }
    }
  }

  removeFromBasket(Item item) {
    if (_basket.isEmpty) {
      notifyListeners();
      return;
    } else {
      Item data = _basket.singleWhere(
          (element) => item.product.id == element.product.id,
          orElse: () => Item(product: Product()));
      if (data.product.id != null) {
        if (data.quantity <= 0) {
          _basket.remove(data);
          notifyListeners();
          return;
        } else {
          int index = _basket.indexOf(data);
          data.quantity--;
          if (data.quantity <= 0) {
            _basket.remove(data);
            notifyListeners();
            return;
          } else
            _basket[index] = data;
          notifyListeners();
        }
      }
    }
    notifyListeners();
  }

  bool deleteItem(Item item) {
    _basket.remove(item);
    notifyListeners();
      return true;
  }

  clearCart() {
    _basket.clear();
    notifyListeners();
  }

  bool isCartEmpty() {
    return _basket.isEmpty ? true : false;
  }

  String getSubPrice() {
    double price = 0;
    _basket.forEach((element) {
      price =
          (double.tryParse(element.product.price!)! * element.quantity) + price;
    });
    return price.toStringAsFixed(2);
  }

  
}
