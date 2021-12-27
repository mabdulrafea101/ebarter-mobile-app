import 'package:fluttercommerce/resources/providers/signup_provider.dart';

class SignupRepository {
  final SignupProvider _signupProvider = SignupProvider();

  Future<String> registerUser(
    String token,
    String username,
    String firstName,
    String lastName,
    String email,
    String password,
  ) =>
      _signupProvider.setData(
          token, username, firstName, lastName, email, password);
}
