// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'package:meta/meta.dart';

class ProductList {
  final List<Product> productList;

  ProductList({@required this.productList});

  factory ProductList.fromJson(List<dynamic> parsedJson) {
    final products = parsedJson.map((p) => Product.fromJson(p)).toList();
    return ProductList(productList: products);
  }
}

class Product {
  Product({
    @required this.id,
    @required this.name,
    @required this.image,
    @required this.slug,
    @required this.estPrice,
    @required this.description,
    @required this.isSold,
    @required this.ratings,
    @required this.reviewComment,
    @required this.isApproved,
    @required this.isRejected,
    @required this.longitude,
    @required this.latitude,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.owner,
    @required this.category,
    @required this.statusByManager,
    @required this.reviewByUser,
  });

  final int id;
  final String name;
  final String image;
  final String slug;
  final int estPrice;
  final String description;
  final bool isSold;
  final dynamic ratings;
  final dynamic reviewComment;
  final bool isApproved;
  final bool isRejected;
  final String longitude;
  final String latitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int owner;
  final int category;
  final int statusByManager;
  final dynamic reviewByUser;

  Product copyWith({
    int id,
    String name,
    String image,
    String slug,
    int estPrice,
    String description,
    bool isSold,
    dynamic ratings,
    dynamic reviewComment,
    bool isApproved,
    bool isRejected,
    String longitude,
    String latitude,
    DateTime createdAt,
    DateTime updatedAt,
    int owner,
    int category,
    int statusByManager,
    dynamic reviewByUser,
  }) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        slug: slug ?? this.slug,
        estPrice: estPrice ?? this.estPrice,
        description: description ?? this.description,
        isSold: isSold ?? this.isSold,
        ratings: ratings ?? this.ratings,
        reviewComment: reviewComment ?? this.reviewComment,
        isApproved: isApproved ?? this.isApproved,
        isRejected: isRejected ?? this.isRejected,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        owner: owner ?? this.owner,
        category: category ?? this.category,
        statusByManager: statusByManager ?? this.statusByManager,
        reviewByUser: reviewByUser ?? this.reviewByUser,
      );

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        image: json["image"] == null ? null : json["image"],
        slug: json["slug"] == null ? null : json["slug"],
        estPrice: json["est_price"] == null ? null : json["est_price"],
        description: json["description"] == null ? null : json["description"],
        isSold: json["is_sold"] == null ? null : json["is_sold"],
        ratings: json["ratings"],
        reviewComment: json["review_comment"],
        isApproved: json["is_approved"] == null ? null : json["is_approved"],
        isRejected: json["is_rejected"] == null ? null : json["is_rejected"],
        longitude: json["longitude"] == null ? null : json["longitude"],
        latitude: json["latitude"] == null ? null : json["latitude"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        owner: json["owner"] == null ? null : json["owner"],
        category: json["category"] == null ? null : json["category"],
        statusByManager: json["status_by_manager"] == null
            ? null
            : json["status_by_manager"],
        reviewByUser: json["review_by_user"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "image": image == null ? null : image,
        "slug": slug == null ? null : slug,
        "est_price": estPrice == null ? null : estPrice,
        "description": description == null ? null : description,
        "is_sold": isSold == null ? null : isSold,
        "ratings": ratings,
        "review_comment": reviewComment,
        "is_approved": isApproved == null ? null : isApproved,
        "is_rejected": isRejected == null ? null : isRejected,
        "longitude": longitude == null ? null : longitude,
        "latitude": latitude == null ? null : latitude,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "owner": owner == null ? null : owner,
        "category": category == null ? null : category,
        "status_by_manager": statusByManager == null ? null : statusByManager,
        "review_by_user": reviewByUser,
      };
}
