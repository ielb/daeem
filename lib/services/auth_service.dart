import 'package:daeem/services/base_api.dart';
import 'package:http/http.dart' as http;

class AuthService extends BaseApi {
  Future<http.Response?> login(String email, String password) async {
    try {
      return await api.httpPost(
          'login', {'email': email.trim(), 'password': password.trim()});
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response?> socialLogin(
      int provider, String email, String uid) async {
    try {
      return await api.httpPost('login_client', {
        'uid': uid,
        'email': email.trim().toLowerCase(),
        'provider': provider == 0 ? 'google' : 'facebook'
      });
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response?> checkEmail(String email) async {
    try {
      return await api.httpPost('client/check_email', {
        'email': email.trim().toLowerCase(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response?> socialRegister(
      int provider, String email, String uid, String name) async {
    try {
      return await api.httpPost('register_client', {
        'uid': uid,
        'name': name.trim().toLowerCase(),
        'email': email.trim().toLowerCase(),
        'provider': provider == 0 ? 'google' : 'facebook'
      });
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response?> register(
      String name, String email, String password) async {
    try {
      return await api.httpPost('register', {
        'name': name.trim().toLowerCase(),
        'email': email.trim().toLowerCase(),
        'password': password.trim()
      });
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response?> getClient(String id) async {
    try {
      return await api.httpGet('client/$id');
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response?> sentVerification() async {
    try {
      return await api.httpGet('user/');
    } catch (e) {
      print(e);
    }
  }

  // Future<http.Response?> logout(){
  //
  //  }

}
