part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupButtonPressed extends SignupEvent {
  final String token;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  SignupButtonPressed({
    @required this.token,
    @required this.username,
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    @required this.password,
  });
}
