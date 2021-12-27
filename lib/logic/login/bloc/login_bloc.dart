import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttercommerce/logic/authentication/bloc/authentication_bloc.dart';
import 'package:fluttercommerce/models/user.dart';
import 'package:fluttercommerce/resources/repositories/authentication_repository.dart';
import 'package:fluttercommerce/resources/repositories/user_repository.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationRepository loginRepository;
  final UserRepository _userRepository = UserRepository();
  final AuthenticationBloc authenticationBloc;
  LoginBloc({
    @required this.loginRepository,
    @required this.authenticationBloc,
  }) : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      print('login loding state way not yield?');
      yield LoginLoading();
      try {
        final token =
            await loginRepository.authenticate(event.email, event.password);
        final userList = await _userRepository.getUserList();
        final user = userList.firstWhere((user) => user.email == event.email);
        final userId = user.id;
        authenticationBloc.add(LoggedIn(token: userId.toString()));

        yield LoginInitial();
      } on SocketException {
        yield LoginFailure(
          error: ('No Internet'),
        );
      } on HttpException {
        yield LoginFailure(
          error: ('No Service'),
        );
      } on FormatException {
        yield LoginFailure(
          error: ('No Formate Exception'),
        );
      } catch (error) {
        yield LoginFailure(error: error.toString());
        print('password, email or both are not correct!, ');
      }
    }
  }
}
