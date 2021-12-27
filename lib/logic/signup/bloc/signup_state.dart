part of 'signup_bloc.dart';

abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLodaded extends SignupState {
  final String message;

  SignupLodaded({@required this.message});
}

class SignupLoading extends SignupState {}

class SignupFaluire extends SignupState {
  final String error;

  SignupFaluire({@required this.error});
}
