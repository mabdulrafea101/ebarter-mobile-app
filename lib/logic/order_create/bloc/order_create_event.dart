part of 'order_create_bloc.dart';

abstract class OrderCreateEvent extends Equatable {
  const OrderCreateEvent();

  @override
  List<Object> get props => [];
}

class CreateOrderButtonPressed extends OrderCreateEvent {
  final String token;
  final String status;
  final int extraPayment;
  final int parcelFromSeller;
  final int parcelFromBuyer;
  final int product1;
  final int product2;

  CreateOrderButtonPressed({
    @required this.token,
    @required this.status,
    @required this.extraPayment,
    @required this.parcelFromBuyer,
    @required this.parcelFromSeller,
    @required this.product1,
    @required this.product2,
  });
}
