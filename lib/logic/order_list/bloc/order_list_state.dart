part of 'order_list_bloc.dart';

abstract class OrderListState extends Equatable {
  const OrderListState();

  @override
  List<Object> get props => [];
}

class OrderListInitial extends OrderListState {}

class OrderListLodaded extends OrderListState {
  final List<Order> orders;

  OrderListLodaded({@required this.orders});
}

class OrderListLoading extends OrderListState {}

class OrderListFaluire extends OrderListState {
  final String error;

  OrderListFaluire({@required this.error});
}
