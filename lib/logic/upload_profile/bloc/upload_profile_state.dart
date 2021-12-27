part of 'upload_profile_bloc.dart';

abstract class UploadProfileState extends Equatable {
  const UploadProfileState();

  @override
  List<Object> get props => [];
}

class UploadProfileInitial extends UploadProfileState {}

class UploadProfileLodaded extends UploadProfileState {
  final String message;

  UploadProfileLodaded({@required this.message});
}

class UploadProfileLoading extends UploadProfileState {}

class UploadProfileFaluire extends UploadProfileState {
  final String error;

  UploadProfileFaluire({@required this.error});
}
