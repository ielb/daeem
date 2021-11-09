import 'dart:convert';

import 'package:daeem/models/market.dart';

class StoreType {
  String id;
  String name;
  String image;
  List<Store> stores = List.empty(growable: true);
  StoreType({
    required this.id,
    required this.name,
    required this.image,
  });


  StoreType copyWith({
    String? id,
    String? name,
    String? image,
  }) {
    return StoreType(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
   


  factory StoreType.fromMap(Map<String, dynamic> map) => StoreType(
      id: map['id'].toString(),
      name: map['name'],
      image:  "https://app.daeem.ma/images/type-store/"+map['image'],
    );

  String toJson() => json.encode(toMap());

  factory StoreType.fromJson(String source) => StoreType.fromMap(json.decode(source));

  @override
  String toString() => 'StoreType(id: $id, name: $name, image: $image)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is StoreType &&
      other.id == id &&
      other.name == name &&
      other.image == image;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ image.hashCode;
}
