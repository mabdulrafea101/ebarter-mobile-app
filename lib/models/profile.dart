// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

// Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

// String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Profile {
  Profile({
    @required this.id,
    @required this.slug,
    @required this.image,
    @required this.phone,
    @required this.updatedAt,
    @required this.user,
    @required this.address1,
    @required this.address2,
  });

  final int id;
  final String slug;
  final dynamic image;
  final dynamic phone;
  final DateTime updatedAt;
  final int user;
  final dynamic address1;
  final dynamic address2;

  Profile copyWith({
    int id,
    String slug,
    dynamic image,
    dynamic phone,
    DateTime updatedAt,
    int user,
    dynamic address1,
    dynamic address2,
  }) =>
      Profile(
        id: id ?? this.id,
        slug: slug ?? this.slug,
        image: image ?? this.image,
        phone: phone ?? this.phone,
        updatedAt: updatedAt ?? this.updatedAt,
        user: user ?? this.user,
        address1: address1 ?? this.address1,
        address2: address2 ?? this.address2,
      );

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        slug: json["slug"],
        image: json["image"],
        phone: json["phone"],
        updatedAt: DateTime.parse(json["updated_at"]),
        user: json["user"],
        address1: json["address1"],
        address2: json["address2"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "slug": slug,
        "image": image,
        "phone": phone,
        "updated_at": updatedAt.toIso8601String(),
        "user": user,
        "address1": address1,
        "address2": address2,
      };
}
