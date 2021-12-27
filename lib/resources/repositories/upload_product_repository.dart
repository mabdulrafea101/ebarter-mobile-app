import 'package:fluttercommerce/resources/providers/upload_product_provider.dart';
import 'package:image_picker/image_picker.dart';

class UploadProductRepository {
  final UploadProductProvider _uploadProductProvider = UploadProductProvider();

  Future<String> postProduct(
    String token,
    String name,
    String slug,
    int estPrice,
    bool isApproved,
    bool isSoled,
    String owner,
    String category,
    String approvedBy,
    int ratings,
    String reviewComment,
    int reviewByUser,
    XFile productImage,
    String description,
    String longitude,
    String latitude,
  ) =>
      _uploadProductProvider.setData(
        token,
        name,
        productImage,
        slug,
        estPrice,
        isApproved,
        isSoled,
        owner,
        category,
        approvedBy,
        ratings,
        reviewComment,
        reviewByUser,
        description,
        longitude,
        latitude,
      );
}
