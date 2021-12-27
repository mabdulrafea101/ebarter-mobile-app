import 'dart:convert';

import 'package:fluttercommerce/constant/constants.dart';
import 'package:http/http.dart' as http;

class SignupProvider {
  Future<String> setData(
    String token,
    String username,
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    final url = Uri.parse("${CustomStrings.baseUrl}/api/user/create/");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    Map bodyData = {
      "email": email,
      "user_name": username,
      "first_name": firstName,
      "last_name": lastName,
      "password": password,
    };
    var body = json.encode(bodyData);
    final response = await http.post(url, body: body, headers: headers);
    final data = jsonDecode(response.body);
    if (response.statusCode != 201) {
      throw Exception(data['status ']);
    } else {
      return 'Product save sucessfully';
    }
  }
}
