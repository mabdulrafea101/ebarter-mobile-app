part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class UpdateProduct extends ProductEvent {
  final String token;

  UpdateProduct({@required this.token});

  @override
  List<Object> get props => [token];
}

class UpdateMyProduct extends ProductEvent {
  final String token;

  UpdateMyProduct({@required this.token});

  @override
  List<Object> get props => [token];
}

class UpdateCategoryProduct extends ProductEvent {
  final String categoryId;

  UpdateCategoryProduct({@required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}

class InitialProductEvent extends ProductEvent {}
