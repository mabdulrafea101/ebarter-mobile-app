import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttercommerce/resources/repositories/parcel_repository.dart';

part 'upload_parcel_event.dart';
part 'upload_parcel_state.dart';

class UploadParcelBloc extends Bloc<UploadParcelEvent, UploadParcelState> {
  final ParcelRepository repository;
  UploadParcelBloc({@required this.repository}) : super(UploadParcelInitial());

  @override
  Stream<UploadParcelState> mapEventToState(UploadParcelEvent event) async* {
    if (event is ParcelUploadButtonPressed) {
      yield UploadParcelLoading();

      try {
        final message = await repository.uploadParcel(
            event.token,
            event.trackingNumber,
            event.massWeight,
            event.shippingCost,
            event.ownProduct,
            event.otherProduct);
        yield UploadParcelLodaded(message: message);
      } on SocketException {
        yield UploadParcelFaluire(
          error: ('No Internet'),
        );
      } on HttpException {
        yield UploadParcelFaluire(
          error: ('No Service'),
        );
      } on FormatException {
        yield UploadParcelFaluire(
          error: ('No Formate Exception'),
        );
      } catch (e) {
        print(e);
        yield UploadParcelFaluire(error: e.toString());
      }
    }
  }
}
