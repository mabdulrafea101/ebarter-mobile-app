import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fluttercommerce/models/order.dart';
import 'package:fluttercommerce/resources/repositories/order_repository.dart';

part 'order_list_event.dart';
part 'order_list_state.dart';

class OrderListBloc extends Bloc<OrderListEvent, OrderListState> {
  final OrderRepository _orderRepository = OrderRepository();
  OrderListBloc() : super(OrderListInitial());

  @override
  Stream<OrderListState> mapEventToState(OrderListEvent event) async* {
    if (event is UpdateOrderList) {
      yield OrderListLoading();

      try {
        final List<Order> orders =
            await _orderRepository.getOrderList(event.token);

        yield OrderListLodaded(orders: orders);
      } on HttpException {
        yield OrderListFaluire(
          error: ('No Service'),
        );
      } on FormatException {
        yield OrderListFaluire(
          error: ('No Formate Exception'),
        );
      } catch (e) {
        print(e);
        yield OrderListFaluire(error: e.toString());
      }
    }
  }
}
