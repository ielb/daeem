


import 'dart:convert';

import 'package:daeem/models/client.dart';
import 'package:daeem/provider/base_provider.dart';
import 'package:daeem/services/client_service.dart';
import 'package:http/http.dart' as http;

class ClientProvider extends BaseProvider {
  var _service = ClientService();
  Client? _client ;
  Client?  get client => _client;
  void setClient(Client val) {
    _client = val;
    notifyListeners();
  } 

 Future<void> updateInfo(String name,String email)async{
    _client!.name = name;
    _client!.email=email;
   http.Response? response = await _service.editClientInfo(_client!);
   if(response!=null&&response.statusCode==200){

     var data = jsonDecode(response.body);
     print(data);
     if(data['status'] == "success"){
       return ;
     }
   }
    notifyListeners();
  }
  
 Future<void> changePassword(String current,String newPassword)async{
   http.Response? response = await _service.changePassword(_client!.id,newPassword);
   if(response!=null&&response.statusCode==200){

     var data = jsonDecode(response.body);
     print(data);
     if(data['status'] == "success"){
       return ;
     }
   }
    notifyListeners();
  }


}