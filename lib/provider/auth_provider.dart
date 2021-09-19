import 'dart:convert';

import 'package:daeem/provider/base_provider.dart';
import 'package:daeem/services/auth_service.dart';
import 'package:daeem/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends BaseProvider {
  AuthService _authService = AuthService();
  Client? _client;
  Client? get client => _client;

  void setClient(Client client) {
    _client = client;
    notifyListeners();
  }

  void setSkipped() {
    Prefs.instance.setSkip();
    notifyListeners();
  }

  Future<bool?> getSkipped() async {
    return await Prefs.instance.getSkipped();
  }

  void setOnBoardingSkipped(bool value) {
    Prefs.instance.setOnBoardingSkip(value);
    notifyListeners();
  }

  Future<bool?> getOnBoardingSkipped() async {
    return await Prefs.instance.getOnBoardingSkipped();
  }



  Future<bool>  socialLogin(String provider) async {
    if (provider == "facebook") {
      setBusy(true);
      final LoginResult result = await FacebookAuth.instance.login();
      print(result.message);
      if (result.status == LoginStatus.success) {
        print("Success");
        final OAuthCredential credential =
        FacebookAuthProvider.credential(result.accessToken!.token);
        UserCredential clientCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
        var response = await _authService.socialLogin(
            1, clientCredential.user!.email!,
            clientCredential.user!.uid);
        print(response?.body);
        if (response != null) {
          var data = jsonDecode(response.body);
          if (data['status'] == "success") {
            var json = data['data'][0];
            setClient(Client.fromJson(json));
            await Prefs.instance.setClient(json['id'].toString());
            print(client);
            setBusy(false);
            await Prefs.instance.setAuth(true);
            return true;
          } else {
            setBusy(false);
            return false;
          }
        }
      }
        return false;
      } else {
        setBusy(true);
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser != null) {
          final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          UserCredential clientCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);
          var response = await _authService.socialLogin(0, clientCredential.user!.email!,
              clientCredential.user!.uid);
          if (response != null) {
            var data = jsonDecode(response.body);
            if (data['status'] == "success") {
              var json = data['data'][0];
              setClient(Client.fromJson(json));
              await Prefs.instance.setClient(json['id'].toString());
              print(client);
              setBusy(false);
              await Prefs.instance.setAuth(true);
              return true;
            } else {
              setBusy(false);
              return false;
            }
          }

        }
        return false;
      }

  }

  socialSignUp(String provider) async {
    if (provider == "facebook") {
      setBusy(true);
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        print("Success");
        final OAuthCredential credential =
        FacebookAuthProvider.credential(result.accessToken!.token);
        UserCredential clientCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
       var response = await _authService.socialRegister(
            1, clientCredential.user!.email!,
            clientCredential.user!.uid, clientCredential.user!.displayName!);
        if (response != null) {
          var data = jsonDecode(response.body);
          if (data['status'] == "success") {
            var json = data['data'];
            setClient(Client.fromJson(json));
            await Prefs.instance.setClient(json['id'].toString());
            print(client);
            setBusy(false);
            await Prefs.instance.setAuth(true);
            return true;
          } else {
            setBusy(false);
            return false;
          }
        }
      }
        return false;
      } else {
        setBusy(true);
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        print("google user");
        if (googleUser != null) {
          final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          UserCredential clientCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);
          var response = await _authService.socialRegister(0, clientCredential.user!.email!,
              clientCredential.user!.uid,clientCredential.user!.displayName!);
          if (response != null) {
            var data = jsonDecode(response.body);
            if (data['status'] == "success") {
              var json = data['data'];
              setClient(Client.fromJson(json));
              await Prefs.instance.setClient(json['id'].toString());
              print(client);
              setBusy(false);
              await Prefs.instance.setAuth(true);
              return true;
            } else {
              setBusy(false);
              return false;
            }
          }
          return false;
        }
      }
  }

  Future<bool> registerWithEmail(
      String name, String email, String password) async {
    setBusy(true);
    http.Response? response = await _authService.register(
        name.trim(), email.toLowerCase().trim(), password.trim());
    print(response?.body);
    if (response != null) {
      var data = jsonDecode(response.body);
      print(data);
      if (data['status'] == "success") {
        setBusy(false);
        return true;
      } else {
        setBusy(false);
        return false;
      }
    }
    notifyListeners();
    return false;
  }

  loginWithEmail(String email, String password) async {
    setBusy(true);
    http.Response? response =
        await _authService.login(email.toLowerCase().trim(), password.trim());
    if (response != null) {
      var data = jsonDecode(response.body);
      if (data['status'] == "success") {
        var json = data['data'][0];
        setClient(Client.fromJson(json));
        await Prefs.instance.setClient(json['id'].toString());
        print(client);
        setBusy(false);
        await Prefs.instance.setAuth(true);
        return true;
      } else {
        setBusy(false);
        return false;
      }
    }
    return false;
  }

 Future<bool> getAuthenticatedClient(id)async{
    http.Response? response = await _authService.getClient(id);
    if(response!=null){
      var json =jsonDecode(response.body);
      print(json);
      if(response.statusCode==200||json['status']=="success"){
        setClient(Client.fromJson(json));
        return true;
      }
      return false;
    }
    return false;
  }



}
