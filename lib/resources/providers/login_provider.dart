import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttercommerce/constant/constants.dart';
import 'package:fluttercommerce/models/login.dart';
import 'package:http/http.dart' as http;

class LoginProvider {
  http.Client client = http.Client();

  Future<String> authenticate({
    @required String email,
    @required String password,
  }) async {
    final url = Uri.parse("${CustomStrings.baseUrl}/api/token/");
    final response = await http.post(url, body: {
      "email": email,
      "password": password,
    });
    print(email);
    print(password);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final loginModel = Login.fromJson(json.decode(response.body));
      return loginModel.refresh;
    } else {
      throw Exception('password, email or both are not correct!');
    }
  }
}
