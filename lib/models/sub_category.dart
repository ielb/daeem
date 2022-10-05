import 'package:daeem/models/product.dart';

class SubCategory {
  int? id;
  String? categoryId;
  String? name;
  String? image;
  String? status;
  List<Product> products = List.empty(growable: true);
  SubCategory({
    this.id,
    this.categoryId,
    this.name,
    this.image,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'name': name,
      'image': image,
      'status': status,
    };
  }

  SubCategory.fromJson(Map<String, dynamic> map) {
    this.id = map['id'];
    this.categoryId = map['categoryId'];
    this.name = map['name'];
    this.image =
        "https://app.serveni.ma/public/images/subcategories/" + map['image'];
    this.status = map['status'];
  }
}
