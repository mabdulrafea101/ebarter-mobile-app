import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fluttercommerce/resources/repositories/order_repository.dart';

part 'order_create_event.dart';
part 'order_create_state.dart';

class OrderCreateBloc extends Bloc<OrderCreateEvent, OrderCreateState> {
  final OrderRepository repository = OrderRepository();
  OrderCreateBloc() : super(OrderCreateInitial());

  @override
  Stream<OrderCreateState> mapEventToState(OrderCreateEvent event) async* {
    if (event is CreateOrderButtonPressed) {
      yield OrderCreateLoading();

      try {
        final String message = await repository.createOrder(
          event.token,
          event.status,
          event.extraPayment,
          event.parcelFromSeller,
          event.parcelFromBuyer,
          event.product1,
          event.product2,
        );

        yield OrderCreateLodaded(message: message);
      } on HttpException {
        yield OrderCreateFaluire(
          error: ('No Service'),
        );
      } catch (e) {
        print(e);
        yield OrderCreateFaluire(error: e.toString());
      }
    }
  }
}
