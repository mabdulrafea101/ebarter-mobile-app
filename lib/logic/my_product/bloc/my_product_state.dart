part of 'my_product_bloc.dart';

abstract class MyProductState extends Equatable {
  const MyProductState();

  @override
  List<Object> get props => [];
}

class MyProductInitial extends MyProductState {}

class MyProductLodaded extends MyProductState {
  final List<Product> products;
  final String userId;

  MyProductLodaded({@required this.products, @required this.userId});
}

class MyProductLoading extends MyProductState {}

class MyProductFaluire extends MyProductState {
  final String error;

  MyProductFaluire({@required this.error});
}
