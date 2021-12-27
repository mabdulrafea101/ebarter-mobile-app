import 'dart:convert';

import 'package:fluttercommerce/constant/constants.dart';
import 'package:http/http.dart' as http;

class PatchOrderProvider {
  Future<String> setData(
    int orderId,
    String status,
    int product1,
    int product2,
  ) async {
    final url = Uri.parse("${CustomStrings.baseUrl}/api/order/$orderId/");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    Map bodyData = {
      "status": status,
      "product_1": product1,
      "product_2": product2,
    };
    var body = json.encode(bodyData);
    final response = await http.patch(url, body: body, headers: headers);
    final data = jsonDecode(response.body);
    if (response.statusCode != 201) {
      throw Exception(data.toString());
    } else {
      return 'Product save sucessfully';
    }
  }
}
