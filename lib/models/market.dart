

class Market{
  int? id;
  String? name;
  String? logo;
  String? cover;
  String? phone;
  String? address;
  int? cityId;
  String? description;
  String? lat;
  String? lng;
  bool? isFakeRating;
  bool? status;

  Market({this.id,this.name,this.logo,this.cover,this.phone,this.address,this.cityId,this.description,this.lat,this.lng,this.isFakeRating,this.status});

  Market.fromJsoN(Map<String,dynamic> json){
    this.id = json['id'];
    this.name= json['name'];
    this.logo= json['logo'];
    this.cover= json['cover'];
    this.phone= json['phone'];
    this.address= json['address'];
    this.cityId= json['city_id'];
    this.description= json['description'];
    this.lat= json['lat'];
    this.lng= json['lng'];
    this.isFakeRating= json['use_fake_rating'];
    this.status= json['status'];
  }

}