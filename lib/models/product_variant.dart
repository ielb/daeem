import 'dart:convert';

// ignore_for_file: non_constant_identifier_names

class Variant {
  int? id;
  String? option;
  String? price;
  String? product_id;
  Variant({
    this.id,
    this.option,
    this.price,
    this.product_id,
  });

  Variant copyWith({
    int? id,
    String? option,
    String? price,
    String? product_id,
  }) {
    return Variant(
      id: id ?? this.id,
      option: option ?? this.option,
      price: price ?? this.price,
      product_id: product_id ?? this.product_id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'option': option,
      'price': price,
      'product_id': product_id,
    };
  }

  factory Variant.fromMap(Map<String, dynamic> map) {
    return Variant(
      id: map['id'],
      option: map['option'],
      price: map['price'],
      product_id: map['product_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Variant.fromJson(String source) => Variant.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Variant(id: $id, option: $option, price: $price, product_id: $product_id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Variant &&
      other.id == id &&
      other.option == option &&
      other.price == price &&
      other.product_id == product_id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      option.hashCode ^
      price.hashCode ^
      product_id.hashCode;
  }
}
