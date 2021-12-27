import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttercommerce/resources/repositories/signup_repository.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupRepository repository;
  SignupBloc({@required this.repository}) : super(SignupInitial());

  @override
  Stream<SignupState> mapEventToState(SignupEvent event) async* {
    if (event is SignupButtonPressed) {
      yield SignupLoading();

      try {
        final String message = await repository.registerUser(
          event.token,
          event.username,
          event.firstName,
          event.lastName,
          event.email,
          event.password,
        );
        yield SignupLodaded(message: message);
      } on HttpException {
        yield SignupFaluire(
          error: ('No Service'),
        );
      } on FormatException {
        yield SignupFaluire(
          error: ('No Formate Exception'),
        );
      } catch (e) {
        print(e);
        yield SignupFaluire(error: e.toString());
      }
    }
  }
}
