import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fluttercommerce/resources/repositories/order_repository.dart';

part 'patch_order_event.dart';
part 'patch_order_state.dart';

class PatchOrderBloc extends Bloc<PatchOrderEvent, PatchOrderState> {
  final OrderRepository repository = OrderRepository();
  PatchOrderBloc() : super(PatchOrderInitial());

  @override
  Stream<PatchOrderState> mapEventToState(PatchOrderEvent event) async* {
    if (event is PatchOrderButtonPressed) {
      yield PatchOrderLoading();

      try {
        final String message = await repository.patchOrder(
            event.orderId, event.status, event.product1, event.product2);

        yield PatchOrderLodaded(message: message);
      } on HttpException {
        yield PatchOrderFaluire(
          error: ('No Service'),
        );
      } on FormatException {
        yield PatchOrderFaluire(
          error: ('No Formate Exception'),
        );
      } catch (e) {
        print(e);
        yield PatchOrderFaluire(error: e.toString());
      }
    }
  }
}
