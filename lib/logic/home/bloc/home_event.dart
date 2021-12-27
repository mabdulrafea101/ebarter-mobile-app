part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class UpdateHome extends HomeEvent {
  final String token;

  UpdateHome({@required this.token});

  @override
  List<Object> get props => [token];
}
