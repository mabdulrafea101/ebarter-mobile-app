// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'package:meta/meta.dart';
// import 'dart:convert';

// List<Welcome> welcomeFromJson(String str) => List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));

// String welcomeToJson(List<Welcome> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserList {
  final List<User> userList;

  UserList({@required this.userList});

  factory UserList.fromJson(List<dynamic> parsedJson) {
    final products = parsedJson.map((p) => User.fromJson(p)).toList();
    return UserList(userList: products);
  }
}

class User {
  User({
    @required this.id,
    @required this.email,
    @required this.userName,
    @required this.firstName,
    @required this.lastName,
  });

  final int id;
  final String email;
  final String userName;
  final String firstName;
  final String lastName;

  User copyWith({
    int id,
    String email,
    String userName,
    String firstName,
    String lastName,
  }) =>
      User(
        id: id ?? this.id,
        email: email ?? this.email,
        userName: userName ?? this.userName,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        userName: json["user_name"],
        firstName: json["first_name"],
        lastName: json["last_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "user_name": userName,
        "first_name": firstName,
        "last_name": lastName,
      };
}
