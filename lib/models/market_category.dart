class MarketCategory {
  int? id;
  String? marketId;
  String? name;
  String? image;
  String? status;
  MarketCategory({
    this.id,
    this.marketId,
    this.name,
    this.image,
    this.status,
  });

  MarketCategory copyWith({
    int? id,
    String? marketId,
    String? name,
    String? image,
    String? status,
  }) {
    return MarketCategory(
      id: id ?? this.id,
      marketId: marketId ?? this.marketId,
      name: name ?? this.name,
      image: image ?? this.image,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'marketId': marketId,
      'name': name,
      'image': image,
      'status': status,
    };
  }

  MarketCategory.fromJson(Map<String, dynamic> map) {
    this.id = map['id'];
    this.marketId = map['supermarket_id'];
    this.name = map['name'];
    this.image =
        "https://app.serveni.ma/public/images/categories/" + map['image'];
    this.status = map['status'];
  }
}
