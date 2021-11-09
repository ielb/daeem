// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:daeem/models/market.dart';
import 'package:daeem/models/order_status.dart';
import 'package:daeem/services/orders_service.dart';
import 'package:daeem/services/store_service.dart';
import 'package:http/http.dart';

class Order {
  int id = 0;
  String address_id = '';
  String code = '';
  String client_id = '';
  Store? store;
  String status_id = '';
  String delivery_price = '';
  String order_price = '';
  String use_coupon = '';
  String? price_after_coupon;
  String? discount_price;
  String use_delivery_time = '';
  String? delivery_pickup_interval;
  bool seen = false;
  bool seen_by_driver = false;
  String? invoice_images;
  String? created_at;
  OrderStatus? current_status;

  List<OrderStatus> order_status = [];
  Order({
    required this.id,
    required this.address_id,
    required this.client_id,
    this.store,
    required this.status_id,
    required this.delivery_price,
    required this.order_price,
    required this.use_coupon,
    this.price_after_coupon,
    this.discount_price,
    required this.use_delivery_time,
    this.delivery_pickup_interval,
    required this.seen,
    required this.seen_by_driver,
    this.invoice_images,
    this.created_at,
  });

  Order copyWith({
    int? id,
    String? address_id,
    String? client_id,
    Store? store,
    String? status_id,
    String? delivery_price,
    String? order_price,
    String? use_coupon,
    String? price_after_coupon,
    String? discount_price,
    String? use_delivery_time,
    String? delivery_pickup_interval,
    bool? seen,
    bool? seen_by_driver,
    String? invoice_images,
    String? created_at,
  }) {
    return Order(
      id: id ?? this.id,
      address_id: address_id ?? this.address_id,
      client_id: client_id ?? this.client_id,
      store: store ?? this.store,
      status_id: status_id ?? this.status_id,
      delivery_price: delivery_price ?? this.delivery_price,
      order_price: order_price ?? this.order_price,
      use_coupon: use_coupon ?? this.use_coupon,
      price_after_coupon: price_after_coupon ?? this.price_after_coupon,
      discount_price: discount_price ?? this.discount_price,
      use_delivery_time: use_delivery_time ?? this.use_delivery_time,
      delivery_pickup_interval:
          delivery_pickup_interval ?? this.delivery_pickup_interval,
      seen: seen ?? this.seen,
      seen_by_driver: seen_by_driver ?? this.seen_by_driver,
      invoice_images: invoice_images ?? this.invoice_images,
      created_at: created_at ?? this.created_at,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'address_id': address_id,
      'client_id': client_id,
      'store': store,
      'status_id': status_id,
      'delivery_price': delivery_price,
      'order_price': order_price,
      'use_coupon': use_coupon,
      'price_after_coupon': price_after_coupon,
      'discount_price': discount_price,
      'use_delivery_time': use_delivery_time,
      'delivery_pickup_interval': delivery_pickup_interval,
      'seen': seen,
      'seen_by_driver': seen_by_driver,
      'invoice_images': invoice_images,
      'created_at': created_at,
    };
  }

  Order.fromMap(Map<String, dynamic> map) {
    getStore(map['store_id']).then((value) {
      this.store = value;
    });
    this.id = map['id'];
    this.code = map['code'];
    this.address_id = map['address_id'];
    this.client_id = map['client_id'];
    this.status_id = map['status_id'];
    this.delivery_price = map['delivery_price'];
    this.order_price = map['order_price'];
    this.use_coupon = map['use_coupon'];
    fillOrderStatus(map['id'].toString(), map['status_id']);
    this.price_after_coupon =
        map['price_after_coupon'] != null ? map['price_after_coupon'] : null;
    this.discount_price =
        map['discount_price'] != null ? map['discount_price'] : null;
    this.use_delivery_time = map['use_delivery_time'];
    this.delivery_pickup_interval = map['delivery_pickup_interval'];
    this.seen = map['seen'] == "0" ? false : true;
    this.seen_by_driver = map['seen_by_driver'] == "0" ? false : true;
    this.invoice_images =
        map['invoice_images'] != null ? map['invoice_images'] : null;
    this.created_at = map['created_at'] != null ? map['created_at'] : null;
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));

  @override
  String toString() {
    return 'id: $id, address_id: $address_id, client_id: $client_id, store_id: ${store?.id}, status_id: $status_id, delivery_price: $delivery_price, order_price: $order_price, use_coupon: $use_coupon, price_after_coupon: $price_after_coupon, discount_price: $discount_price, use_delivery_time: $use_delivery_time, delivery_pickup_interval: $delivery_pickup_interval, seen: $seen, seen_by_driver: $seen_by_driver, invoice_images: $invoice_images, created_at: $created_at';
  }

  Future<Store?> getStore(String id) async {
    StoreService service = StoreService();
    Response? response = await service.getMarketById(int.parse(id));
    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') return Store.fromJson(data['data']);
    }
    return null;
  }

  void fillOrderStatus(String id,String statusId) async {
    this.order_status.clear();
    OrderService service = OrderService();
    Response? response = await service.getOrderHistory(id);
    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
         print("id  : $statusId");
        data['data'].forEach((element) {
          this.order_status.add(OrderStatus.fromMap(element));
       
          if (element['status_id'].toString() == statusId) {
            this.current_status = OrderStatus.fromMap(element);
            print("id ${current_status?.status['name']}");
          }
        });
      }
    }
    return null;
  }
}


/*
  "id": 15,
                "code": "110645",
                "address_id": "1",
                "client_id": "1",
                "store_id": "2",
                "user_id": "2",
                "collector_id": "2",
                "status_id": "4",
                "delivery_price": "10.00",
                "order_price": "30.40",
                "use_coupon": "0",
                "price_after_coupon": null,
                "discount_price": null,
                "payment_method": "cash",
                "use_delivery_time": "0",
                "delivery_time": null,
                "delivery_pickup_interval": "01:10",
                "seen": "1",
                "seen_by_driver": "1",
                "seen_by_collector": "0",
                "invoice_images": null,
                "created_at": "2021-09-25T11:06:45.000000Z",
*/