import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fluttercommerce/logic/my_product/bloc/my_product_bloc.dart';
import 'package:fluttercommerce/models/product.dart';
import 'package:fluttercommerce/resources/repositories/product_repository.dart';
import 'package:fluttercommerce/resources/repositories/profile_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;
  ProductBloc({@required this.repository}) : super(ProductInitial());

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is UpdateProduct) {
      print('this');
      yield ProductLoading();

      try {
        final List<Product> products =
            await repository.fetchProducts(event.token);
        yield ProductLodaded(products: products);
      } on SocketException {
        yield ProductFaluire(
          error: ('No Internet'),
        );
      } on HttpException {
        yield ProductFaluire(
          error: ('No Service'),
        );
      } on FormatException {
        yield ProductFaluire(
          error: ('No Formate Exception'),
        );
      } catch (e) {
        print(e);
        yield ProductFaluire(error: e.toString());
      }
    } else if (event is UpdateMyProduct) {
      yield ProductLoading();

      try {
        final List<Product> products =
            await repository.fetchMyProducts(event.token);
        yield ProductLodaded(products: products);
      } on SocketException {
        yield ProductFaluire(
          error: ('No Internet'),
        );
      } on HttpException {
        yield ProductFaluire(
          error: ('No Service'),
        );
      } on FormatException {
        yield ProductFaluire(
          error: ('No Formate Exception'),
        );
      } catch (e) {
        print(e);
        yield ProductFaluire(error: e.toString());
      }
    } else if (event is UpdateCategoryProduct) {
      yield ProductLoading();

      try {
        final List<Product> products =
            await repository.fetchCategoryProducts(event.categoryId);
        yield ProductLodaded(products: products);
      } on SocketException {
        yield ProductFaluire(
          error: ('No Internet'),
        );
      } on HttpException {
        yield ProductFaluire(
          error: ('No Service'),
        );
      } on FormatException {
        yield ProductFaluire(
          error: ('No Formate Exception'),
        );
      } catch (e) {
        print(e);
        yield ProductFaluire(error: e.toString());
      }
    } else if (event is InitialProductEvent) {
      yield ProductInitial();
    }
  }
}
