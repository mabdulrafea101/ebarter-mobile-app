part of 'upload_product_bloc.dart';

abstract class UploadProductState extends Equatable {
  const UploadProductState();

  @override
  List<Object> get props => [];
}

class UploadProductInitial extends UploadProductState {}

class UploadProductLodaded extends UploadProductState {
  final String message;

  UploadProductLodaded({@required this.message});
}

class UploadProductLoading extends UploadProductState {}

class UploadProductFaluire extends UploadProductState {
  final String error;

  UploadProductFaluire({@required this.error});
}
