part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLodaded extends ProductState {
  final List<Product> products;

  ProductLodaded({@required this.products});
}

class ProductLoading extends ProductState {}

class ProductFaluire extends ProductState {
  final String error;

  ProductFaluire({@required this.error});
}
