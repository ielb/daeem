import 'dart:convert';



class OrderdProduct {
  String name;
  String image;
  String price;
  String quantity;
  String? variant;
  bool  isHadVariant;
  OrderdProduct({
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.isHadVariant,
    this.variant
  });

  OrderdProduct copyWith({
    String? name,
    String? image,
    String? price,
    String? quantity,
    bool? isHadVariant, 
  }) {
    return OrderdProduct(
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      isHadVariant: isHadVariant ?? this.isHadVariant,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
    };
  }

  factory OrderdProduct.fromMap(Map<String, dynamic> map) {
    return OrderdProduct(
      name: map['name'],
      isHadVariant: map['has_variants']=='0' ? false : true,
      image:"https://app.daeem.ma/images/products/" + map['image'],
      price: map['price'],
      variant: map['variant']  ,
      quantity: map['qty'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderdProduct.fromJson(String source) => OrderdProduct.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderdProduct(name: $name, image: $image, price: $price, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is OrderdProduct &&
      other.name == name &&
      other.image == image &&
      other.price == price &&
      other.quantity == quantity;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      image.hashCode ^
      price.hashCode ^
      quantity.hashCode;
  }
}
