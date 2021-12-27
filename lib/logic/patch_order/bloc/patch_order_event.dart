part of 'patch_order_bloc.dart';

abstract class PatchOrderEvent extends Equatable {
  const PatchOrderEvent();

  @override
  List<Object> get props => [];
}

class PatchOrderButtonPressed extends PatchOrderEvent {
  final String status;
  final int orderId;
  final int product1;
  final int product2;

  PatchOrderButtonPressed({
    @required this.orderId,
    @required this.status,
    @required this.product1,
    @required this.product2,
  });
}
