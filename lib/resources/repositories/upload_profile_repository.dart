import 'package:fluttercommerce/resources/providers/upload_profile_provider.dart';

class UploadProfileRepository {
  final UploadProfileProvider provider = UploadProfileProvider();

  Future<String> putProfile(
    String slug,
    String phone,
    // XFile productImage,
    String address,
    String userId,
  ) =>
      provider.setData(
        slug,
        phone,
        userId,
        address,
      );
}
