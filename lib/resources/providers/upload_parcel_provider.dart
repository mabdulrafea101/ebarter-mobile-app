import 'dart:convert';

import 'package:fluttercommerce/constant/constants.dart';
import 'package:http/http.dart' as http;

class UploadParcelProvider {
  Future<String> setData(
    String token,
    int trackingNumber,
    String massWeight,
    int shippingCost,
    bool dispatched,
    int ownProduct,
    int otherProduct,
  ) async {
    final url = Uri.parse("${CustomStrings.baseUrl}/api/order/parcel/create/");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    Map bodyData = {
      "tracking_number": trackingNumber,
      "mass_weight": massWeight,
      "shipping_cost": shippingCost,
      "dispatched": dispatched,
      "product": ownProduct,
      "product_for": otherProduct,
    };
    var body = json.encode(bodyData);
    final response = await http.post(url, body: body, headers: headers);
    final data = jsonDecode(response.body);
    if (response.statusCode != 201) {
      throw Exception(data.toString());
    } else {
      return 'Product save sucessfully';
    }
  }
}
