import 'dart:convert';

import 'package:fluttercommerce/constant/constants.dart';
import 'package:fluttercommerce/models/user.dart';
import 'package:http/http.dart' as http;

class UserProvider {
  http.Client client = http.Client();

  Future<List<User>> getData(String token) async {
    print('$token token');
    final url = Uri.parse("${CustomStrings.baseUrl}/api/user/");
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      UserList users = UserList.fromJson(json.decode(response.body));
      return users.userList;
    } else {
      throw Exception('Failed to load Legal Files');
    }
  }
}
