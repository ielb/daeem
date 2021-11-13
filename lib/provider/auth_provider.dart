// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:convert';

import 'package:daeem/provider/base_provider.dart';
import 'package:daeem/services/auth_service.dart';
import 'package:daeem/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  bool isAuth() {
    return _client == null ? false : true;
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

  Future<bool> socialLogin(String provider) async {
    Prefs.instance.setPlatform(true);
    if (provider == "facebook") {
      setBusy(true);
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        UserCredential clientCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        var emailResult = await checkEmail(clientCredential.user!.email!);
        if (emailResult == true) {
          var response = await _authService.socialLogin(
              1, clientCredential.user!.email!, clientCredential.user!.uid);
          if (response != null) {
            var data = jsonDecode(response.body);
            if (data['status'] == "success") {
              var json = data['data'];
              var client_data = json['client'];
              var address_data = json['address'];
              setClient(Client.fromJson(client_data, address_data));
              Prefs.instance.setClient(_client!.id.toString());
              notifyListeners();
              return true;
            } else {
              return false;
            }
          }
        }
      } else {
        notifyListeners();
        return false;
      }
      return false;
    } else {
      try {
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
          var emailResult = await checkEmail(clientCredential.user!.email!);
          if (emailResult == true) {
            var response = await _authService.socialLogin(
                0, clientCredential.user!.email!, clientCredential.user!.uid);
            if (response != null) {
              var data = jsonDecode(response.body);
              if (data['status'] == "success") {
                var json = data['data'];
                var client_data = json['client'];
                var address_data = json['address'];

                setClient(Client.fromJson(client_data, address_data));
                Prefs.instance.setClient(_client!.id.toString());

                notifyListeners();

                return true;
              } else {
                notifyListeners();
                return false;
              }
            }
          }
        }
        notifyListeners();
        return false;
      } catch (error) {
        print(error);
      }
      notifyListeners();
      return false;
    }
  }

  socialSignUp(String provider) async {
    try {
      if (provider == "facebook") {
        setBusy(true);
        final LoginResult result = await FacebookAuth.instance.login();
        if (result.status == LoginStatus.success) {
          final OAuthCredential credential =
              FacebookAuthProvider.credential(result.accessToken!.token);
          UserCredential clientCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);
          var emailResult = await checkEmail(clientCredential.user!.email!);
          if (emailResult == false) {
            var response = await _authService.socialRegister(
                1,
                clientCredential.user!.email!,
                clientCredential.user!.uid,
                clientCredential.user!.displayName!);
            if (response != null) {
              var data = jsonDecode(response.body);
              if (data['status'] == "success") {
                var json = data['data'];
                var client_data = json['client'];
                var address_data = json['address'];

                setClient(Client.fromJson(client_data, address_data));
                Prefs.instance.setClient(_client!.id.toString());

                notifyListeners();

                return true;
              } else {
                notifyListeners();
                return false;
              }
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

          var emailResult = await checkEmail(clientCredential.user!.email!);
          if (emailResult == false) {
            var response = await _authService.socialRegister(
                0,
                clientCredential.user!.email!,
                clientCredential.user!.uid,
                clientCredential.user!.displayName!);
            if (response != null) {
              var data = jsonDecode(response.body);
              if (data['status'] == "success") {
                var json = data['data'];
                var client_data = json['client'];
                var address_data = json['address'];

                setClient(Client.fromJson(client_data, address_data));
                Prefs.instance.setClient(_client!.id.toString());

                notifyListeners();

                return true;
              } else {
                notifyListeners();
                return false;
              }
            }
            return false;
          }
        }
      }
    } catch (error) {
      print(error);
    }
    return false;
  }

  Future<bool> registerWithEmail(
      String name, String email, String password) async {
    setBusy(true);
    http.Response? response = await _authService.register(
        name.trim(), email.toLowerCase().trim(), password.trim());

    if (response != null) {
      var data = jsonDecode(response.body);

      if (data['status'] == "success") {
        notifyListeners();
        return true;
      } else {
        notifyListeners();
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
        var json = data['data'];
        var client_data = json['client'];
        var address_data = json['address'];

        setClient(Client.fromJson(client_data, address_data));
        Prefs.instance.setClient(_client!.id.toString());

        notifyListeners();

        return true;
      } else {
        notifyListeners();
        return false;
      }
    }
    return false;
  }

  Future<bool> getAuthenticatedClient(id) async {
    http.Response? response = await _authService.getClient(id);
    if (response != null) {
      var json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status'] == "success") {
        setClient(
            Client.fromJson(json['data']['client'], json['data']['address']));
        return true;
      }
      return false;
    }
    return false;
  }

  Future<bool> logOut() async {
    setBusy(false);
    var google = await GoogleSignIn().isSignedIn();
    var facebook = await FacebookAuth.instance.accessToken;
    if (facebook != null) FacebookAuth.instance.logOut();
    if (google) {
      await GoogleSignIn().signOut();
    }
    _client = null;
    var prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
    return true;
  }

  checkEmail(String email) async {
    http.Response? response = await _authService.checkEmail(email);
    if (response != null) {
      var json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status'] == "success") {
        return true;
      }
      return false;
    }
  }
}
