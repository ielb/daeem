import 'package:http/http.dart' as http;


class Api {
  static final _api =Api._internal();
  factory Api(){
    return _api;
  }
  Api._internal();
  String url = "https://app.daeem.ma/api/";

  // ignore: todo
  //TODO:HERE YOU CHANGE THE BEARER TOKEN
  var headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer oo3aD8L8TjT8huLCI8OzpZXX2u7uWsEzaCslXs2k',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  Future<http.Response?> httpGet(String endPath,{Map<String,dynamic>? query}) async {
    try{
      Uri uri = Uri.parse('$url$endPath');
      return http.get(uri,headers:headers);
    }catch(e){
      print(e);
    }

  }

  Future<http.Response?> httpPost(String endPath,Object body)async{
    try{
      Uri uri = Uri.parse('$url$endPath');
      return http.post(uri,body:body,headers:headers);
    }catch(e){
      print(e);
    }
  }


}