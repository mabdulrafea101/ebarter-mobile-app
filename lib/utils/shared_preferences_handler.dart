import 'package:fluttercommerce/constant/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHandler {
  static SharedPreferences _pref;
  static setToken(String token) async {
    if (_pref == null) {
      _pref = await SharedPreferences.getInstance();
    }
    _pref.setString(CustomStrings.kTokenKey, token);
  }

  // static _initPref() async {

  // }

  static Future<String> getToken() async {
    if (_pref == null) {
      _pref = await SharedPreferences.getInstance();
    }

    return _pref.getString(CustomStrings.kTokenKey);
  }
}
