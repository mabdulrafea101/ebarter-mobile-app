part of 'order_create_bloc.dart';

abstract class OrderCreateState extends Equatable {
  const OrderCreateState();

  @override
  List<Object> get props => [];
}

class OrderCreateInitial extends OrderCreateState {}

class OrderCreateLodaded extends OrderCreateState {
  final String message;

  OrderCreateLodaded({@required this.message});
}

class OrderCreateLoading extends OrderCreateState {}

class OrderCreateFaluire extends OrderCreateState {
  final String error;

  OrderCreateFaluire({@required this.error});
}
