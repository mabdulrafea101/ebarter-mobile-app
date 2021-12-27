part of 'upload_parcel_bloc.dart';

abstract class UploadParcelEvent extends Equatable {
  const UploadParcelEvent();

  @override
  List<Object> get props => [];
}

class ParcelUploadButtonPressed extends UploadParcelEvent {
  final String token;
  final int trackingNumber;
  final String massWeight;
  final int shippingCost;
  final int ownProduct;
  final int otherProduct;

  ParcelUploadButtonPressed({
    @required this.token,
    @required this.trackingNumber,
    @required this.massWeight,
    @required this.shippingCost,
    @required this.ownProduct,
    @required this.otherProduct,
  });
}
