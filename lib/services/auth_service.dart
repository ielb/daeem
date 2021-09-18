




import 'package:daeem/services/base_api.dart';
import 'package:http/http.dart' as http;


class AuthService extends BaseApi {

  Future<http.Response?> login(String email, String password) async{
    try {
      return await api.httpPost('login', {'email': email.trim(), 'password': password.trim()});
    } catch (e) {
      print(e);
    }
   }
  Future<http.Response?> socialLogin(int platform,String email, String uid) async{
    try {
      if(platform==0)
        return await api.httpPost('login_google', {'email': email.trim(), 'go_id': uid});
      else
        return await api.httpPost('login_facebook', {'email': email.trim(), 'fb_id': uid});
    } catch (e) {
      print(e);
    }
  }
  Future<http.Response?>  socialRegister(int platform,String email, String uid,String name)async{
    try {
      if(platform==0)
        return await api.httpPost('register_google', {'name':name.trim().toLowerCase(),'email': email.trim().toLowerCase(), 'uid': uid.trim()});
      else
        return await api.httpPost('register_facebook', {'name':name.trim().toLowerCase(),'email': email.trim().toLowerCase(), 'uid': uid.trim()});
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response?>  register(String name,String email, String password)async{
    try {
      return await api.httpPost('register', {'name':name.trim().toLowerCase(),'email': email.trim().toLowerCase(), 'password': password.trim()});
    } catch (e) {
      print(e);
    }
   }
  Future<http.Response?> getClient(String id)async{
    try {
      return await api.httpGet('user/$id');
    } catch (e) {
      print(e);
    }
   }

  // Future<http.Response?> logout(){
  //
  //  }


}