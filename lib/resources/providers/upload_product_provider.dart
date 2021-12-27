import 'dart:convert';

import 'package:fluttercommerce/constant/constants.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class UploadProductProvider {
  Future<String> setData(
    String token,
    String name,
    XFile productImage,
    String slug,
    int estPrice,
    bool isApproved,
    bool isSoled,
    String owner,
    String category,
    String approvedBy,
    int ratings,
    String reviewComment,
    int reviewByUser,
    String description,
    String longitude,
    String latitude,
  ) async {
    if (name == null) {
      final url = Uri.parse("${CustomStrings.baseUrl}/api/product/$token/");
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      Map bodyData = {
        "ratings": ratings,
        "review_comment": reviewComment,
        "review_by_user": reviewByUser,
      };
      var body = json.encode(bodyData);
      print(body);
      final response = await http.patch(url, body: body, headers: headers);
      final data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw Exception(data['status']);
      } else {
        return 'Comment save sucessfully';
      }
    } else {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      var formData = FormData.fromMap({
        "name": name,
        'image': await MultipartFile.fromFile(productImage.path,
            filename: productImage.path),
        "est_price": estPrice,
        "owner": owner,
        "category": category,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
      });
      var dio = Dio();
      var response = await dio.post(
          "${CustomStrings.baseUrl}/api/product/create/",
          data: formData,
          options: Options(headers: headers));
      if (response.statusCode != 200) {
        throw Exception('Something went worng please try again!');
      } else {
        return 'Product save sucessfully';
      }
    }
  }
}
