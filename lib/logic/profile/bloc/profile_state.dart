part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLodaded extends ProfileState {
  final Profile profile;

  ProfileLodaded({@required this.profile});
}

class ProfileLoading extends ProfileState {}

class ProfileFaluire extends ProfileState {
  final String error;

  ProfileFaluire({@required this.error});
}
