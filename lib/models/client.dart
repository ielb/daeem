
import 'package:daeem/models/address.dart';

class Client {
  String? id ;
  String? name;
  String? email;
  Address? address;
  String? phone;
  String? token;
  Client({this.id,this.name,this.email,this.address,this.phone});

  // ignore: non_constant_identifier_names
  Client.fromJson(Map<dynamic,dynamic> client_data,Map<String,dynamic>? address_data,){
    this.id=client_data['id'].toString();
    this.name=client_data['name'];
    this.email=client_data['email'];
    this.phone=client_data['phone'];
    this.token = client_data['client_token'];
    this.address= address_data != null ? Address.fromMap(address_data) :  null;
  }


  Map<dynamic,dynamic> toJson(){
   return  <dynamic,dynamic>{
      'id':this.id,
      'name':this.name,
      'phone':this.phone
    };
  }
}