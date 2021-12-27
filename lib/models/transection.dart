// To parse this JSON data, do
//
//     final transection = transectionFromJson(jsonString);

import 'package:meta/meta.dart';
// ata) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransectionList {
  final List<Transection> productList;

  TransectionList({@required this.productList});

  factory TransectionList.fromJson(List<dynamic> parsedJson) {
    final products = parsedJson.map((p) => Transection.fromJson(p)).toList();
    return TransectionList(productList: products);
  }
}

class Transection {
  Transection({
    @required this.id,
    @required this.transectionNumber,
    @required this.transferedAmount,
    @required this.forOrder,
    @required this.forShipping,
    @required this.isDeposit,
    @required this.isWithdrawl,
    @required this.createdAt,
    @required this.senderWallet,
    @required this.receiverWallet,
  });

  final int id;
  final String transectionNumber;
  final int transferedAmount;
  final bool forOrder;
  final bool forShipping;
  final bool isDeposit;
  final bool isWithdrawl;
  final DateTime createdAt;
  final int senderWallet;
  final int receiverWallet;

  Transection copyWith({
    int id,
    String transectionNumber,
    int transferedAmount,
    bool forOrder,
    bool forShipping,
    bool isDeposit,
    bool isWithdrawl,
    DateTime createdAt,
    int senderWallet,
    int receiverWallet,
  }) =>
      Transection(
        id: id ?? this.id,
        transectionNumber: transectionNumber ?? this.transectionNumber,
        transferedAmount: transferedAmount ?? this.transferedAmount,
        forOrder: forOrder ?? this.forOrder,
        forShipping: forShipping ?? this.forShipping,
        isDeposit: isDeposit ?? this.isDeposit,
        isWithdrawl: isWithdrawl ?? this.isWithdrawl,
        createdAt: createdAt ?? this.createdAt,
        senderWallet: senderWallet ?? this.senderWallet,
        receiverWallet: receiverWallet ?? this.receiverWallet,
      );

  factory Transection.fromJson(Map<String, dynamic> json) => Transection(
        id: json["id"] == null ? null : json["id"],
        transectionNumber: json["transection_number"] == null
            ? null
            : json["transection_number"],
        transferedAmount: json["transfered_amount"] == null
            ? null
            : json["transfered_amount"],
        forOrder: json["for_order"] == null ? null : json["for_order"],
        forShipping: json["for_shipping"] == null ? null : json["for_shipping"],
        isDeposit: json["is_deposit"] == null ? null : json["is_deposit"],
        isWithdrawl: json["is_withdrawl"] == null ? null : json["is_withdrawl"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        senderWallet:
            json["sender_wallet"] == null ? null : json["sender_wallet"],
        receiverWallet:
            json["receiver_wallet"] == null ? null : json["receiver_wallet"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "transection_number":
            transectionNumber == null ? null : transectionNumber,
        "transfered_amount": transferedAmount == null ? null : transferedAmount,
        "for_order": forOrder == null ? null : forOrder,
        "for_shipping": forShipping == null ? null : forShipping,
        "is_deposit": isDeposit == null ? null : isDeposit,
        "is_withdrawl": isWithdrawl == null ? null : isWithdrawl,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "sender_wallet": senderWallet == null ? null : senderWallet,
        "receiver_wallet": receiverWallet == null ? null : receiverWallet,
      };
}
