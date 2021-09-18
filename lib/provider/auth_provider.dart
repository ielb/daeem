import 'dart:convert';

import 'package:daeem/models/client.dart';
import 'package:daeem/preferences/prefs.dart';
import 'package:daeem/provider/base_provider.dart';
import 'package:daeem/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart'as http;



class AuthProvider extends BaseProvider {
  AuthService _authService =  AuthService();
  Client? _client ;
  Client? get client => _client;

  void setClient(Client client){
    _client = client;
    notifyListeners();
  }

  void setSkipped() {
    Prefs.instance.setSkip();
    notifyListeners();
  }

  Future<bool?> getSkipped() async{
     return await Prefs.instance.getSkipped();
  }
  void setOnBoardingSkipped(bool value) {
    Prefs.instance.setOnBoardingSkip(value);
    notifyListeners();
  }

  Future<bool?> getOnBoardingSkipped() async{
    return await Prefs.instance.getOnBoardingSkipped();
  }
  ///Google
  Future<bool>  registerWithGoogle(bool isLogin)async{
    setBusy(true);
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if(googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential clientCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      Map<dynamic,dynamic> data = {
        'id':clientCredential.user!.uid,
        'name':clientCredential.user!.displayName,
        'email':clientCredential.user!.email
      };
      http.Response? response =  isLogin ? await
      _authService.socialLogin(0, clientCredential.user!.email!, clientCredential.user!.uid) : await
      _authService.socialRegister(0, clientCredential.user!.email!, clientCredential.user!.uid,clientCredential.user!.displayName!);
      var result = jsonDecode(response!.body);
      if(result['status'] =="success") {
        setClient(Client.fromJson(data));
        Prefs.instance.setAuth(true);
        setBusy(false);
        return true;
      }

    }else{

      setBusy(false);
      return false;
    }
    setBusy(false);
    return true;

  }

  ///Facebook
 Future<bool>  registerWithFacebook(bool isLogin) async{
   setBusy(true);
    final LoginResult result = await FacebookAuth.instance.login();
    if(result.status == LoginStatus.success){
      print("Success");
      final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
      UserCredential clientCredential =  await FirebaseAuth.instance.signInWithCredential(credential);
      Map<dynamic,dynamic> data = {
        'id':clientCredential.user!.uid,
        'name':clientCredential.user!.displayName,
        'email':clientCredential.user!.email
      };
      http.Response? response =  isLogin ? await
      _authService.socialLogin(1, clientCredential.user!.email!, clientCredential.user!.uid) : await
      _authService.socialRegister(1, clientCredential.user!.email!, clientCredential.user!.uid,clientCredential.user!.displayName!);
      var responseResult = jsonDecode(response!.body);
      if(responseResult['status'] =="success") {
        setClient(Client.fromJson(data));
        Prefs.instance.setAuth(true);
        setBusy(false);
        return true;
      }
    }else{
      print("Something went wrong!");
      setBusy(false);
      return false;
    }
    setBusy(false);
    return false;

  }
 Future<bool> registerWithEmail(String name,String email,String password)async{
    setBusy(true);
    http.Response? response = await _authService.register(name.trim(), email.toLowerCase().trim(), password.trim());
   if(response!=null){
     var data = jsonDecode(response.body);
      if(data['status']=="success"){
        setClient(Client(name: name,email:email));
        setBusy(false);
        Prefs.instance.setAuth(true);
        return true;
      }else{
        setBusy(false);
        return false;
      }
   }
    notifyListeners();
    return false;
  }

  loginWithEmail(String email,String password)async{
    setBusy(true);
    http.Response? response = await _authService.login(email.toLowerCase().trim(), password.trim());
    if(response!=null){
      var data = jsonDecode(response.body);
      if(data['status']=="success"){
        var json = data['data'][0];
        setClient(Client.fromJson(json));
        print(client);
        setBusy(false);
        Prefs.instance.setAuth(true);
        return true;
      }else{
        setBusy(false);
        return false;
      }
    }
    loginWithEmail(email, password);
    notifyListeners();
  }




}