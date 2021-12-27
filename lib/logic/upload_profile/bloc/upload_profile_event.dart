part of 'upload_profile_bloc.dart';

abstract class UploadProfileEvent extends Equatable {
  const UploadProfileEvent();

  @override
  List<Object> get props => [];
}

class UploadProfileButtonPressed extends UploadProfileEvent {
  final String slug;
  final String address;
  final String phone;
  final String userId;
  // final XFile image;

  UploadProfileButtonPressed({
    @required this.slug,
    @required this.address,
    @required this.phone,
    @required this.userId,
    // @required this.image,
  });
}
