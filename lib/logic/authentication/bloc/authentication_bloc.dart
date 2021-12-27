import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercommerce/resources/repositories/authentication_repository.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository loginRepository;

  // var authenticationRepository;
  AuthenticationBloc({@required this.loginRepository})
      : super(AuthenticationInitial());
  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      print('AuthenticationBloc AppStarted');
      final bool hasToken = await loginRepository.hasToken();

      if (hasToken) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      print('AuthenticationBloc LoggedIn 000000000');
      yield AuthenticationLoading();
      loginRepository.persistToken(event.token);
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      print('AuthenticationBloc LoggedOut');
      yield AuthenticationLoading();
      loginRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }
}
