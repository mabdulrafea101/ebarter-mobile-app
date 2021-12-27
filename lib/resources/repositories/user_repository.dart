import 'package:fluttercommerce/models/user.dart';
import 'package:fluttercommerce/resources/providers/user_provider.dart';

class UserRepository {
  final UserProvider _provider = UserProvider();

  Future<List<User>> getUserList() => _provider.getData('token');
}
