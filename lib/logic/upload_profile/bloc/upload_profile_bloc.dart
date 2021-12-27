import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fluttercommerce/resources/repositories/upload_profile_repository.dart';

part 'upload_profile_event.dart';
part 'upload_profile_state.dart';

class UploadProfileBloc extends Bloc<UploadProfileEvent, UploadProfileState> {
  final UploadProfileRepository _repository = UploadProfileRepository();
  UploadProfileBloc() : super(UploadProfileInitial()) {
    on<UploadProfileEvent>((event, emit) async {
      if (event is UploadProfileButtonPressed) {
        emit(UploadProfileLoading());
        try {
          final String message = await _repository.putProfile(
              event.slug, event.phone, event.address, event.userId);
          emit(UploadProfileLodaded(message: message));
        } on HttpException {
          emit(UploadProfileFaluire(
            error: ('No Service'),
          ));
        } on FormatException {
          emit(UploadProfileFaluire(
            error: ('No Formate Exception'),
          ));
        } catch (e) {
          print(e);
          emit(UploadProfileFaluire(error: e.toString()));
        }
      }
    });
  }
}
