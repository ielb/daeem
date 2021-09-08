import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  Prefs._privateConstructor();

  static Prefs instance = Prefs._privateConstructor();

  setLanguageCode(String languageCode) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('language_code', languageCode);
  }

  Future<String?> getLanguageCode() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('language_code');
  }
}
