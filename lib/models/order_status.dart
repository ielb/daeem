// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:daeem/configs/config.dart';

class OrderStatus {
  int id;
  String order_id;
  Map<String,dynamic> status;
  String created_at;
  OrderStatus({
    required this.id,
    required this.order_id,
    required this.status,
    required this.created_at,
  });

  OrderStatus copyWith({
    int? id,
    String? order_id,
    Map<String,dynamic>? status,
    String? client_id,
    String? created_at,
  }) {
    return OrderStatus(
      id: id ?? this.id,
      order_id: order_id ?? this.order_id,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': order_id,
      'status_id': status,
      'created_at': created_at,
    };
  }

  factory OrderStatus.fromMap(Map<String, dynamic> map) {
    return OrderStatus(
      id: map['id'],
      order_id: map['order_id'],
      status:Config.getStatus(int.parse(map['status_id'].toString())),
      created_at: map['created_at'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderStatus.fromJson(String source) => OrderStatus.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderStatus(id: $id, order_id: $order_id, status_id: ${status['id']}, created_at: $created_at)';
  }

 

}
