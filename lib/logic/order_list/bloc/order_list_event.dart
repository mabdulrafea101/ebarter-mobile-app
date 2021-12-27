part of 'order_list_bloc.dart';

abstract class OrderListEvent extends Equatable {
  const OrderListEvent();

  @override
  List<Object> get props => [];
}

class UpdateOrderList extends OrderListEvent {
  final String token;

  UpdateOrderList({@required this.token});

  @override
  List<Object> get props => [token];
}
