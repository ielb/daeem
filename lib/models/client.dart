
import 'package:daeem/models/address.dart';

class Client {
  String? id ;
  String? name;
  String? email;
  Address? address;
  String? phone;
  String? token;
  Client({this.id,this.name,this.email,this.address,this.phone});

  Client.fromJson(Map<dynamic,dynamic> json){
    this.id=json['id'].toString();
    this.name=json['name'];
    this.email=json['email'];
    this.phone=json['phone'];
    this.token = json['client_token'];
  }


  Map<dynamic,dynamic> toJson(){
   return  <dynamic,dynamic>{
      'id':this.id,
      'name':this.name,
      'phone':this.phone
    };
  }
}