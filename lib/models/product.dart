

class Product {
    int?  id;
    String? supermarketId;
    String? sku ;
    String? name;       
    String? description;
    String? image;
    String? price;
    String? weight;
    String? subCategoryId;
    bool?  available;
    bool? status    ;  
    int quantity = 0; 
    Product({this.id,this.supermarketId,this.sku,this.name,this.description,this.image,this.price,this.weight,this.subCategoryId,this.available,this.status}); 
    Product.fromJson(Map<String,dynamic> json){
      this.id = json['id'];
      this.supermarketId =json['supermarket_id'];
      this.sku = json['sku'];
      this.name = json['name'];
      this.description = json['description'];
      this.image = "https://app.daeem.ma/images/products/"+json['image'];
      this.price = json['price'];
      this.weight = json['weight'];
      this.subCategoryId = json[''];
      this.available = json['available'] == 0 ? false: true;
      this.status = json['status'] == 0 ? false :true;
    }
}
