import 'package:flutter/cupertino.dart';

@immutable
class MembershipEntry {
  final String retailerId;
  final String barcode;

  const MembershipEntry({required this.retailerId, required this.barcode});

  MembershipEntry.fromJson(Map<String, dynamic> json)
      : this(
            retailerId: json['retailerId'] as String,
            barcode: json['barcode'] as String);

  Map<String, dynamic> toJson() {
    return {'retailerId': retailerId, 'barcode': barcode};
  }
}
