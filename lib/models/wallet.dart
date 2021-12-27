import 'package:meta/meta.dart';

class Wallet {
  Wallet({
    @required this.id,
    @required this.currentAmount,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.walletHolder,
  });

  final int id;
  final int currentAmount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int walletHolder;

  Wallet copyWith({
    int id,
    int currentAmount,
    DateTime createdAt,
    DateTime updatedAt,
    int walletHolder,
  }) =>
      Wallet(
        id: id ?? this.id,
        currentAmount: currentAmount ?? this.currentAmount,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        walletHolder: walletHolder ?? this.walletHolder,
      );

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        id: json["id"] == null ? null : json["id"],
        currentAmount:
            json["current_amount"] == null ? null : json["current_amount"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        walletHolder:
            json["wallet_holder"] == null ? null : json["wallet_holder"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "current_amount": currentAmount == null ? null : currentAmount,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "wallet_holder": walletHolder == null ? null : walletHolder,
      };
}
