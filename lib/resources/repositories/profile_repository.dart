import 'package:fluttercommerce/models/profile.dart';
import 'package:fluttercommerce/resources/providers/profile_provider.dart';

class ProfileRepository {
  final ProfileProvider _profileProvider = ProfileProvider();

  Future<Profile> fetchProfileData(String token, String userId) =>
      _profileProvider.getData(token, userId);
}
