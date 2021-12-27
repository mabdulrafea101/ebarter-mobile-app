// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'package:meta/meta.dart';
// import 'dart:convert';

// List<Welcome> welcomeFromJson(String str) => List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));

// String welcomeToJson(List<Welcome> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderList {
  final List<Order> orderList;

  OrderList({@required this.orderList});

  factory OrderList.fromJson(List<dynamic> parsedJson) {
    final products = parsedJson.map((p) => Order.fromJson(p)).toList();
    return OrderList(orderList: products);
  }
}

class Order {
  Order({
    @required this.id,
    @required this.status,
    @required this.extraPayment,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.product1,
    @required this.product2,
    @required this.approvalFrom,
  });

  final int id;
  final String status;
  final int extraPayment;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int product1;
  final int product2;
  final int approvalFrom;

  Order copyWith({
    int id,
    String status,
    int extraPayment,
    DateTime createdAt,
    DateTime updatedAt,
    int product1,
    int product2,
    int approvalFrom,
  }) =>
      Order(
        id: id ?? this.id,
        status: status ?? this.status,
        extraPayment: extraPayment ?? this.extraPayment,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        product1: product1 ?? this.product1,
        product2: product2 ?? this.product2,
        approvalFrom: approvalFrom ?? this.approvalFrom,
      );

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"] == null ? null : json["id"],
        status: json["status"] == null ? null : json["status"],
        extraPayment:
            json["extra_payment"] == null ? null : json["extra_payment"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        product1: json["product_1"] == null ? null : json["product_1"],
        product2: json["product_2"] == null ? null : json["product_2"],
        approvalFrom:
            json["approval_from"] == null ? null : json["approval_from"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "status": status == null ? null : status,
        "extra_payment": extraPayment == null ? null : extraPayment,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "product_1": product1 == null ? null : product1,
        "product_2": product2 == null ? null : product2,
        "approval_from": approvalFrom == null ? null : approvalFrom,
      };
}
