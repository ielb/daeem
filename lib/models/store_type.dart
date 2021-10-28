import 'dart:convert';

class StoreType {
  String? id;
  String? name;
  String? image;
  StoreType({
    this.id,
    this.name,
    this.image,
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

  factory StoreType.fromMap(Map<String, dynamic> map) {
    return StoreType(
      id: map['id'] != null ? map['id'].toString() : null,
      name: map['name'] != null ?  map['name'] : null,
      image: map['image'] != null ? "https://app.daeem.ma/images/type-store/"+map['image'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreType.fromJson(String source) =>
      StoreType.fromMap(json.decode(source));

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
