import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fluttercommerce/constant/constants.dart';
import 'package:http/http.dart' as http;

class OrderCreateProvider {
  Future<String> setData(
    String token,
    String status,
    int extraPayment,
    int requestFrom,
    int approvalFrom,
    int product1,
    int product2,
  ) async {
    Response response;
    var dio = Dio();
    var formData = FormData.fromMap({
      'product_1': product1,
      'product_2': product2,
    });
    response = await dio.request(
      '${CustomStrings.baseUrl}/api/order/create/',
      data: formData,
      options: Options(
          followRedirects: false,
          // will not throw errors
          validateStatus: (status) => true,
          headers: {
            'Content-type': 'multipart/form-data',
            'Accept': 'application/json',
          },
          method: 'POST'),
    );
    if (response.statusCode == 400) {
      throw Exception('${response.data}');
    } else if (response.statusCode != 200) {
      print('Something went worng please try again! ${response.data}');
      throw Exception(
          'Something went worng please try again! ${response.statusCode}');
    } else {
      return 'Product save sucessfully';
    }
  }
}
