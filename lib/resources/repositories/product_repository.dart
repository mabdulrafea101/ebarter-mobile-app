// import 'package:flutter/foundation.dart';
import 'package:fluttercommerce/models/catogary.dart';
import 'package:fluttercommerce/models/product.dart';
import 'package:fluttercommerce/resources/providers/category_product_provider.dart';
import 'package:fluttercommerce/resources/providers/my_product_provider.dart';
import 'package:fluttercommerce/resources/providers/product_provider.dart';

class ProductRepository {
  final ProductProvider _provider = ProductProvider();
  final MyProductProvider _myProductProvider = MyProductProvider();
  final CategoryProductProvider _categoryProductProvider =
      CategoryProductProvider();
  Future<List<Product>> fetchProducts(String token) =>
      _provider.getProductData(token);

  Future<List<Category>> fetchCategories(String token) =>
      _provider.getCategoryData(token);

  Future<List<Product>> fetchMyProducts(String token) =>
      _myProductProvider.getProductData(token);

  Future<List<Product>> fetchCategoryProducts(String categoryId) =>
      _categoryProductProvider.getProductData(categoryId);
}
