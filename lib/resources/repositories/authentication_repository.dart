import 'package:fluttercommerce/constant/constants.dart';
import 'package:fluttercommerce/resources/providers/login_provider.dart';
import 'package:fluttercommerce/utils/shared_preferences_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationRepository {
  final loginProvider = LoginProvider();
  Future<String> authenticate(String email, String password) async {
    print('run this function authenticate');
    String token;
    try {
      token =
          await loginProvider.authenticate(email: email, password: password);
    } catch (e) {
      return Future.error(e, StackTrace.fromString("This is its trace"));
    }

    SharedPreferences sharedPrafrence = await SharedPreferences.getInstance();

    await sharedPrafrence.setString(CustomStrings.kTokenKey, token);
    print(token);
    return token;
  }

  void deleteToken() async {
    print('remove toke');
    SharedPreferences sharedPrafrence = await SharedPreferences.getInstance();
    await sharedPrafrence.remove(CustomStrings.kTokenKey);
  }

  void persistToken(String token) async {
    SharedPreferencesHandler.setToken(token);
  }

  Future<bool> hasToken() async {
    SharedPreferences sharedPrafrence = await SharedPreferences.getInstance();
    if (sharedPrafrence.containsKey(CustomStrings.kTokenKey)) {
      print('it has token');
      return true;
    } else
      print('it has not  token');
    return false;
  }
}
