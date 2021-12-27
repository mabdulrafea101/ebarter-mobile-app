import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fluttercommerce/models/product.dart';
import 'package:fluttercommerce/resources/repositories/product_repository.dart';
import 'package:fluttercommerce/utils/shared_preferences_handler.dart';

part 'my_product_event.dart';
part 'my_product_state.dart';

class MyProductBloc extends Bloc<MyProductEvent, MyProductState> {
  ProductRepository _repository = ProductRepository();
  MyProductBloc() : super(MyProductInitial());

  @override
  Stream<MyProductState> mapEventToState(MyProductEvent event) async* {
    if (event is UpdateMyProduct) {
      yield MyProductLoading();

      try {
        final List<Product> products =
            await _repository.fetchProducts(event.token);
        final String userId = await SharedPreferencesHandler.getToken();

        yield MyProductLodaded(products: products, userId: userId);
      } on SocketException {
        yield MyProductFaluire(
          error: ('No Internet'),
        );
      } on HttpException {
        yield MyProductFaluire(
          error: ('No Service'),
        );
      } on FormatException {
        yield MyProductFaluire(
          error: ('No Formate Exception'),
        );
      } catch (e) {
        print(e);
        yield MyProductFaluire(error: e.toString());
      }
    }
  }
}
