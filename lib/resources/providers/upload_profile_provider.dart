import 'dart:convert';

import 'package:fluttercommerce/constant/constants.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UploadProfileProvider {
  Future<String> setData(
    String slug,
    String phone,
    // XFile productImage,
    String userId,
    String address,
  ) async {
    final url = Uri.parse("${CustomStrings.baseUrl}/api/user/profile/$userId/");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    Map bodyData = {
      // 'product_image': await MultipartFile.fromFile(productImage.path,
      //     filename: productImage.path),
      "slug": slug,
      "phone": phone,
      "address1": address,
      'user': int.parse(userId),
      'longitude': 0,
      'latitude': 0,
    };
////////////////////

    var body = json.encode(bodyData);
    final response = await http.patch(url, body: body, headers: headers);
    final data = jsonDecode(response.body);
    if (response.statusCode != 200) {
      print('kkkkkkkkkkkkkkk');
      throw Exception(data['status']);
    } else {
      return 'Profile save sucessfully';
    }
  }
}
