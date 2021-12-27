// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

// List<Welcome> welcomeFromJson(String str) => List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));

// String welcomeToJson(List<Welcome> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryList {
  final List<Category> categories;

  CategoryList({@required this.categories});

  factory CategoryList.fromJson(List<dynamic> parsedJson) {
    final categories = parsedJson.map((p) => Category.fromJson(p)).toList();
    return CategoryList(categories: categories);
  }
}

class Category {
  Category({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.image,
    @required this.isActive,
    @required this.createdAt,
    @required this.updatedAt,
  });

  final int id;
  final String name;
  final String description;
  final String image;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category copyWith({
    int id,
    String name,
    String description,
    String image,
    bool isActive,
    DateTime createdAt,
    DateTime updatedAt,
  }) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        image: image ?? this.image,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "image": image,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
