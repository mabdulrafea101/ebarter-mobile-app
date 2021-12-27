import 'dart:convert';

import 'package:fluttercommerce/constant/constants.dart';
import 'package:fluttercommerce/models/wallet.dart';
import 'package:http/http.dart' as http;

class WalletProvider {
  http.Client client = http.Client();

  Future<Wallet> getData(String id) async {
    final url = Uri.parse("${CustomStrings.baseUrl}/api/payments/wallet/$id/");
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      Wallet wallet = Wallet.fromJson(json.decode(response.body));
      return wallet;
    } else {
      throw Exception('Failed to load Legal Files');
    }
  }

  Future<String> setData(String id, String currentAmount, String title) async {
    final url = Uri.parse("${CustomStrings.baseUrl}/api/payments/wallet/$id/");

    final body = {
      'current_amount': currentAmount,
      'wallet_holder': id,
    };
    final jsonBody = json.encode(body);
    final response = await client.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonBody);
    if (response.statusCode == 200) {
      return '$title Amount sucessfully';
    } else {
      throw Exception('$title Amount unsucessfully');
    }
  }
}
