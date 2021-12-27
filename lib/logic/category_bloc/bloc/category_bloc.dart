import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttercommerce/models/catogary.dart';
import 'package:fluttercommerce/resources/repositories/product_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final ProductRepository repository = ProductRepository();
  CategoryBloc() : super(CategoryInitial()) {
    on<CategoryEvent>((event, emit) async {
      if (event is UpdateCategory) {
        print('Update Category Event run');
        emit(CategoryLoading());

        try {
          final List<Category> categories =
              await repository.fetchCategories('token');
          emit(CategoryLoaded(categories: categories));
        } catch (e) {
          emit(CategoryFailure());
        }
      }
    });
  }
}
