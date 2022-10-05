import 'dart:convert';

import 'package:daeem/models/product_variant.dart';

class Product {
  int? id;
  String? supermarketId;
  String? sku;
  String? name;
  String? description;
  String? image;
  String? price;
  String? weight;
  String? subCategoryId;
  bool? available;
  bool? status;
  int? hasVariant;
  Variant? currentVariant;
  List<Variant> variants = [];

  Product({
    this.id,
    this.supermarketId,
    this.sku,
    this.name,
    this.description,
    this.image,
    this.price,
    this.weight,
    this.subCategoryId,
    this.available,
    this.status,
    this.hasVariant,
    this.variants = const [],
  });

  Product copyWith({
    int? id,
    String? supermarketId,
    String? sku,
    String? name,
    String? description,
    String? image,
    String? price,
    String? weight,
    String? subCategoryId,
    bool? available,
    bool? status,
    int? hasVariant,
  }) {
    return Product(
      id: id ?? this.id,
      supermarketId: supermarketId ?? this.supermarketId,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      weight: weight ?? this.weight,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      available: available ?? this.available,
      status: status ?? this.status,
      hasVariant: hasVariant ?? this.hasVariant,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'supermarketId': supermarketId,
      'sku': sku,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'weight': weight,
      'subCategoryId': subCategoryId,
      'available': available,
      'status': status,
      'hasVariant': hasVariant,
    };
  }

  factory Product.fromMap(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      supermarketId: json['supermarket_id'],
      sku: json['sku'],
      name: json['name'],
      description: json['description'],
      image: "https://app.serveni.ma/images/products/" + json['image'],
      price: json['price'],
      weight: json['weight'],
      subCategoryId: json[''],
      available: json['available'] == 0 ? false : true,
      status: json['status'] == 0 ? false : true,
      hasVariant: int.parse(json['has_variants'].toString()),
      variants: json['variants'].length != 0
          ? List<Variant>.from(json['variants'].map((x) => Variant.fromMap(x)))
          : List<Variant>.empty(growable: true),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Product(id: $id, supermarketId: $supermarketId, sku: $sku, name: $name, description: $description, image: $image, price: $price, weight: $weight, subCategoryId: $subCategoryId, available: $available, status: $status, hasVariant: $hasVariant)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.supermarketId == supermarketId &&
        other.sku == sku &&
        other.name == name &&
        other.description == description &&
        other.image == image &&
        other.price == price &&
        other.weight == weight &&
        other.subCategoryId == subCategoryId &&
        other.available == available &&
        other.status == status &&
        other.hasVariant == hasVariant;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        supermarketId.hashCode ^
        sku.hashCode ^
        name.hashCode ^
        description.hashCode ^
        image.hashCode ^
        price.hashCode ^
        weight.hashCode ^
        subCategoryId.hashCode ^
        available.hashCode ^
        status.hashCode ^
        hasVariant.hashCode;
  }
}
