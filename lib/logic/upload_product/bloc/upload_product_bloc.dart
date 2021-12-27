import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fluttercommerce/resources/repositories/upload_product_repository.dart';
import 'package:image_picker/image_picker.dart';

part 'upload_product_event.dart';
part 'upload_product_state.dart';

class UploadProductBloc extends Bloc<UploadProductEvent, UploadProductState> {
  final UploadProductRepository repository = UploadProductRepository();
  UploadProductBloc() : super(UploadProductInitial());

  @override
  Stream<UploadProductState> mapEventToState(UploadProductEvent event) async* {
    if (event is ProductUpladButtonPressed) {
      yield UploadProductLoading();

      try {
        final String message = await repository.postProduct(
          event.token,
          event.name,
          event.slug,
          event.estPrice,
          event.isApproved,
          event.isSoled,
          event.owner,
          event.category,
          event.approvedBy,
          event.ratings,
          event.reviewComment,
          event.reviewByUser,
          event.productImage,
          event.description,
          event.longitude,
          event.latitude,
        );
        yield UploadProductLodaded(message: message);
      } on HttpException {
        yield UploadProductFaluire(
          error: ('No Service'),
        );
      } on FormatException {
        yield UploadProductFaluire(
          error: ('No Formate Exception'),
        );
      } catch (e) {
        print(e);
        yield UploadProductFaluire(error: e.toString());
      }
    } else if (event is ResetUploadProduct) {
      yield UploadProductInitial();
    }
  }
}
