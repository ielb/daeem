// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:daeem/configs/config.dart';
import 'package:daeem/models/OrderProduct.dart';
import 'package:daeem/models/status.dart';
import 'package:flutter/foundation.dart';

import 'package:daeem/models/market.dart';

class Order {
  int id = 0;
  String address_id = '';
  String code = '';
  String client_id = '';
  Store? store; 
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
  String created_at;
  Status current_status;
  List<OrderdProduct> products;
  List<Status> status_history;
  Order({
    required this.id,
    required this.address_id,
    required this.code,
    required this.client_id,
    this.store,
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
    required this.created_at,
    required this.current_status,
    required this.status_history,
    required this.products,
  });


  Order copyWith({
    int? id,
    String? address_id,
    String? code,
    String? client_id,
    Store? store,
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
    Status? current_status,
    List<Status>? status_history,
  }) {
    return Order(
      id: id ?? this.id,
      address_id: address_id ?? this.address_id,
      code: code ?? this.code,
      client_id: client_id ?? this.client_id,
      store: store ?? this.store,
      delivery_price: delivery_price ?? this.delivery_price,
      order_price: order_price ?? this.order_price,
      use_coupon: use_coupon ?? this.use_coupon,
      price_after_coupon: price_after_coupon ?? this.price_after_coupon,
      discount_price: discount_price ?? this.discount_price,
      use_delivery_time: use_delivery_time ?? this.use_delivery_time,
      delivery_pickup_interval: delivery_pickup_interval ?? this.delivery_pickup_interval,
      seen: seen ?? this.seen,
      seen_by_driver: seen_by_driver ?? this.seen_by_driver,
      invoice_images: invoice_images ?? this.invoice_images,
      created_at: created_at ?? this.created_at,
      current_status: current_status ?? this.current_status,
      status_history: status_history ?? this.status_history,
      products:  this.products,
    );
  }

 

  factory Order.fromMap(Map<String, dynamic> map) {
    print(map['products_']);
    return Order(
      id: map['id'],
      address_id: map['address_id'],
      code: map['code'],
      client_id: map['client_id'],
      store: map['store'] != null ? Store.fromJson(map['store']) : null,
      delivery_price: map['delivery_price'],
      order_price: map['order_price'],
      use_coupon: map['use_coupon'],
      price_after_coupon: map['price_after_coupon'] != null ? map['price_after_coupon'] : null,
      discount_price: map['discount_price'] != null ? map['discount_price'] : null,
      use_delivery_time: map['use_delivery_time'],
      delivery_pickup_interval: map['delivery_pickup_interval'] != null ? map['delivery_pickup_interval'] : null,
      seen: map['seen']=="1" ? true : false,
      seen_by_driver: map['seen_by_driver']=="1" ? true : false,
      invoice_images: map['invoice_images'] != null ? map['invoice_images'] : null,
      created_at: map['created_at'],
      products: (map['products_'] as List)
          .map((e) => OrderdProduct.fromMap(e as Map<String, dynamic>))
          .toList(),
      current_status: Status.fromMap( Config.getStatus(int.parse(map['status_id'].toString()))),
      status_history: (map['statuses'] as List<dynamic>).map((e) => Status.fromMap(Config.getStatus(int.parse(e['status_id'].toString()),date:e['created_at']))).toList(),
    );
  }


  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Order(id: $id, address_id: $address_id, code: $code, client_id: $client_id, store: $store, delivery_price: $delivery_price, order_price: $order_price, use_coupon: $use_coupon, price_after_coupon: $price_after_coupon, discount_price: $discount_price, use_delivery_time: $use_delivery_time, delivery_pickup_interval: $delivery_pickup_interval, seen: $seen, seen_by_driver: $seen_by_driver, invoice_images: $invoice_images, created_at: $created_at, current_status: $current_status, status_history: $status_history)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Order &&
      other.id == id &&
      other.address_id == address_id &&
      other.code == code &&
      other.client_id == client_id &&
      other.store == store &&
      other.delivery_price == delivery_price &&
      other.order_price == order_price &&
      other.use_coupon == use_coupon &&
      other.price_after_coupon == price_after_coupon &&
      other.discount_price == discount_price &&
      other.use_delivery_time == use_delivery_time &&
      other.delivery_pickup_interval == delivery_pickup_interval &&
      other.seen == seen &&
      other.seen_by_driver == seen_by_driver &&
      other.invoice_images == invoice_images &&
      other.created_at == created_at &&
      other.current_status == current_status &&
      listEquals(other.status_history, status_history);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      address_id.hashCode ^
      code.hashCode ^
      client_id.hashCode ^
      store.hashCode ^
      delivery_price.hashCode ^
      order_price.hashCode ^
      use_coupon.hashCode ^
      price_after_coupon.hashCode ^
      discount_price.hashCode ^
      use_delivery_time.hashCode ^
      delivery_pickup_interval.hashCode ^
      seen.hashCode ^
      seen_by_driver.hashCode ^
      invoice_images.hashCode ^
      created_at.hashCode ^
      current_status.hashCode ^
      status_history.hashCode;
  }
}
