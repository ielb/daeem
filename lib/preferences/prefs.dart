import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  Prefs._privateConstructor();

  static Prefs instance = Prefs._privateConstructor();
 //locale
  setLanguageCode(String languageCode) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('language_code', languageCode);
  }
  Future<String?> getLanguageCode() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('language_code');
  }
  //login/sing up
  setSkip()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('skipped', true);
  }

  Future<bool?> getSkipped() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('skipped');
  }
  //onboard
  setOnBoardingSkip(bool value)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('skipped', value);
  }

  Future<bool?> getOnBoardingSkipped() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('skipped');
  }



  //Auth
  setAuth(bool value)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isAuthenticated', value);
  }


  Future<bool?> getAuth() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAuthenticated');
  }
  ///client
  setClient(String id,)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('client_id', id);
  }
  Future<String?> getClient()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('client_id');
  }
}
