import 'dart:convert';

import 'package:daeem/models/product.dart';
import 'package:daeem/models/product_variant.dart';

class Item {
  Product product;
  int quantity;
  Variant? variant;
  
  Item({
    required this.product,
    this.quantity=0,
    this.variant,
  });
 

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
      'variant': variant?.toMap(),
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      product: Product.fromMap(map['product']),
      quantity: map['quantity'],
      variant: map['variant'] != null ? Variant.fromMap(map['variant']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) => Item.fromMap(json.decode(source));

  @override
  String toString() => 'Item(product: $product, quantity: $quantity, variant: $variant)';
   }

 

