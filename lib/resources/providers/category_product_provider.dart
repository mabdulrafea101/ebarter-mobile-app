import 'dart:convert';

import 'package:fluttercommerce/constant/constants.dart';
import 'package:fluttercommerce/models/catogary.dart';
import 'package:fluttercommerce/models/product.dart';
import 'package:http/http.dart' as http;

class CategoryProductProvider {
  http.Client client = http.Client();

  Future<List<Product>> getProductData(String categoryId) async {
    final url = Uri.parse(
        "${CustomStrings.baseUrl}/api/product/?category_id=$categoryId");
    final response = await client.get(url
        // headers: {
        //   'Content-Type': 'application/json',
        //   'Accept': 'application/json',
        //   'Authorization':
        //       "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzIiwianRpIjoiY2U3MGEzN2Y0MzEyYThiZTQwYWY2MzEyNTBlOTZlMGEwNTNkNzRlOGJhYjEzNzllMjZkYmZmYTBhM2FjNTdlYTc2N2UwNDdlNWIzZTZjZTYiLCJpYXQiOjE2MzM0OTg0ODYuMDA3MDg1LCJuYmYiOjE2MzM0OTg0ODYuMDA3MDkxLCJleHAiOjE2NjUwMzQ0ODUuOTk3NzQsInN1YiI6IjIwMjQiLCJzY29wZXMiOltdfQ.pBBho0fG0IEjPNCgadMv4BSfx1C7Er6d1jOQ7VOxRNySvFc9aDtsDF8XWmd_0tgYaoMCNeJxYfPXBuKqwIBFI0fss_9SqxTBF4ebvdGylK8WPais3a2BFoNS6ZH14SHgF-kGTYSrUF20alJuwpSijQPytucI8yJpcHrG2bqyhf8UlzHm5ajKfpozW208mryNCskStN8zNJYG9CMG2_E1OYZyumpQIlqamGz4W7vy68A1ogNmq2vGCssLox6F7l50n8f8z-PbRkBLabs8n_1ujhixTvrIwvhMCcy9hxON7AB9VRGt6JcBz5AAOWUkw1huuwAcg4MTTwEq2js4EuNkmZWPa1A9Y1NIoN0DhFdpIkvJAAfC0M1Nu7CJZdg_mPP4iRQdxM9l6sBt0_yTYYCuOcRSEO6503iMq0Gcbrwtf89cU4u3bLYlusah_rRApm2aD6evx6sIHjrP0XUQuypoekb7BQnsnfYhK3pCjlialBB9ergwRfkizyE9t8dsVN70CpKZEuSJyne8lQv0VCB9KgawWlZyOaRr4MrMFUT4Q8531SAUNpmLgJ-YhoGePaaTWPfu_cxZ9IG1uyKP8ONGfE9K118I2OGopiY9w-X8BFmEoJJprKWy1wlkNaOaX68CK_C-mwI_eVMwR2j7b3I3T3JmsMEj7YzV0gmryFJcAWs",
        // },
        );
    if (response.statusCode == 200) {
      ProductList products = ProductList.fromJson(json.decode(response.body));
      return products.productList;
    } else {
      throw Exception('Failed to load Legal Files');
    }
  }
}
