// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class Coupon {
  int? id;
  String? code;
  String? name;
  String? description;
  String? discount_price;
  String? active_from;
  String? active_to;
  String? limit_to_num_uses;
  int? used_count;
  String? status;
  Coupon({
    this.id,
    this.code,
    this.name,
    this.description,
    this.discount_price,
    this.active_from,
    this.active_to,
    this.limit_to_num_uses,
    this.used_count,
    this.status,
  });
  

  Coupon copyWith({
    int? id,
    String? code,
    String? name,
    String? description,
    String? discount_price,
    String? active_from,
    String? active_to,
    String? limit_to_num_uses,
    int? used_count,
    String? status,
  }) {
    return Coupon(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      discount_price: discount_price ?? this.discount_price,
      active_from: active_from ?? this.active_from,
      active_to: active_to ?? this.active_to,
      limit_to_num_uses: limit_to_num_uses ?? this.limit_to_num_uses,
      used_count: used_count ?? this.used_count,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'discount_price': discount_price,
      'active_from': active_from,
      'active_to': active_to,
      'limit_to_num_uses': limit_to_num_uses,
      'used_count': used_count,
      'status': status,
    };
  }

  factory Coupon.fromMap(Map<String, dynamic> map) {
    return Coupon(
      id: map['id'],
      code: map['code'],
      name: map['name'],
      description: map['description'],
      discount_price: map['discount_price'],
      active_from: map['active_from'],
      active_to: map['active_to'],
      limit_to_num_uses: map['limit_to_num_uses'],
      used_count: map['used_count'],
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Coupon.fromJson(String source) => Coupon.fromMap(jsonDecode(source));

  @override
  String toString() {
    return 'Coupon(id: $id, code: $code, name: $name, description: $description, discount_price: $discount_price, active_from: $active_from, active_to: $active_to, limit_to_num_uses: $limit_to_num_uses, used_count: $used_count, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Coupon &&
      other.id == id &&
      other.code == code &&
      other.name == name &&
      other.description == description &&
      other.discount_price == discount_price &&
      other.active_from == active_from &&
      other.active_to == active_to &&
      other.limit_to_num_uses == limit_to_num_uses &&
      other.used_count == used_count &&
      other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      code.hashCode ^
      name.hashCode ^
      description.hashCode ^
      discount_price.hashCode ^
      active_from.hashCode ^
      active_to.hashCode ^
      limit_to_num_uses.hashCode ^
      used_count.hashCode ^
      status.hashCode;
  }
}
