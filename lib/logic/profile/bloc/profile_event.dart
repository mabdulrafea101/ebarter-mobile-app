part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class UpdateProfile extends ProfileEvent {
  final String token;
  final String userId;

  UpdateProfile({@required this.token, @required this.userId});

  @override
  List<Object> get props => [token, this.userId];
}
