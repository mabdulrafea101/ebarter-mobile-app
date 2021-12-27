// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

// Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

// String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Login {
  Login({
    @required this.refresh,
    @required this.access,
  });

  final String refresh;
  final String access;

  Login copyWith({
    String refresh,
    String access,
  }) =>
      Login(
        refresh: refresh ?? this.refresh,
        access: access ?? this.access,
      );

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        refresh: json["refresh"],
        access: json["access"],
      );

  Map<String, dynamic> toJson() => {
        "refresh": refresh,
        "access": access,
      };
}
