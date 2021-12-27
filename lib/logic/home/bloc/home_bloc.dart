import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fluttercommerce/models/catogary.dart';
import 'package:fluttercommerce/models/product.dart';
import 'package:fluttercommerce/resources/repositories/product_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProductRepository repository;

  HomeBloc({@required this.repository}) : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is UpdateHome) {
      yield HomeLoading();

      try {
        List<Product> products = await repository.fetchProducts(event.token);
        List<Category> categories =
            await repository.fetchCategories(event.token);
        yield HomeLodaded(products: products, categories: categories);
      } on SocketException {
        yield HomeFaluire(
          error: ('No Internet'),
        );
      } on HttpException {
        yield HomeFaluire(
          error: ('No Service'),
        );
      } on FormatException {
        yield HomeFaluire(
          error: ('No Formate Exception'),
        );
      } catch (e) {
        print(e);
        yield HomeFaluire(error: e.toString());
      }
    }
  }
}
