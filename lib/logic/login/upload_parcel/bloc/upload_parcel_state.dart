part of 'upload_parcel_bloc.dart';

abstract class UploadParcelState extends Equatable {
  const UploadParcelState();

  @override
  List<Object> get props => [];
}

class UploadParcelInitial extends UploadParcelState {}

class UploadParcelLodaded extends UploadParcelState {
  final String message;

  UploadParcelLodaded({@required this.message});
}

class UploadParcelLoading extends UploadParcelState {}

class UploadParcelFaluire extends UploadParcelState {
  final String error;

  UploadParcelFaluire({@required this.error});
}
