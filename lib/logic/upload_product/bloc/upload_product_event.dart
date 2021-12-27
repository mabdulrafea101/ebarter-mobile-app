part of 'upload_product_bloc.dart';

abstract class UploadProductEvent extends Equatable {
  const UploadProductEvent();

  @override
  List<Object> get props => [];
}

class ProductUpladButtonPressed extends UploadProductEvent {
  final String token;
  final String name;
  final String slug;
  final int estPrice;
  final bool isApproved;
  final bool isSoled;
  final String owner;
  final String category;
  final String approvedBy;
  final int ratings;
  final String reviewComment;
  final int reviewByUser;
  final XFile productImage;
  final String description;
  final String longitude;
  final String latitude;

  ProductUpladButtonPressed({
    @required this.token,
    @required this.name,
    @required this.slug,
    @required this.estPrice,
    @required this.approvedBy,
    @required this.isSoled,
    @required this.owner,
    @required this.category,
    @required this.isApproved,
    @required this.ratings,
    @required this.reviewComment,
    @required this.reviewByUser,
    @required this.productImage,
    @required this.description,
    @required this.longitude,
    @required this.latitude,
  });

  @override
  List<Object> get props => [token];
}

class ResetUploadProduct extends UploadProductEvent {}
