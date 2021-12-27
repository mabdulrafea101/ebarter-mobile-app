import 'package:fluttercommerce/resources/providers/upload_parcel_provider.dart';

class ParcelRepository {
  final UploadParcelProvider _uploadParcelProvider = UploadParcelProvider();

  Future<String> uploadParcel(
    String token,
    int trackingNumber,
    String massWeight,
    int shippingCost,
    int ownProduct,
    int otherProduct,
  ) =>
      _uploadParcelProvider.setData(token, trackingNumber, massWeight,
          shippingCost, true, ownProduct, otherProduct);
}
