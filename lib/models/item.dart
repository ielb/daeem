import 'dart:convert';

import 'package:daeem/models/product.dart';

class Item {
  Product product;
  int quantity;
  String variant;
  
  Item({
    required this.product,
    this.quantity=0,
    this.variant="item",
  });
 
 

  Item copyWith({
    Product? product,
    int? quantity,
    String? variant,
  }) {
    return Item(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      variant: variant ?? this.variant,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
      'variant': variant,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      product: Product.fromMap(map['product']),
      quantity: map['quantity'],
      variant: map['variant'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) => Item.fromMap(json.decode(source));

  @override
  String toString() => 'Item(product: $product, quantity: $quantity, variant: $variant)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Item &&
      other.product == product &&
      other.quantity == quantity &&
      other.variant == variant;
  }

  @override
  int get hashCode => product.hashCode ^ quantity.hashCode ^ variant.hashCode;
  }

 

