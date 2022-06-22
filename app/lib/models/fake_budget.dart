import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
class FakeBudget {
  final String range;
  final num amount;
  final String uuid;


  const FakeBudget(
      {required this.range,
        required this.amount,
        required this.uuid});

  FakeBudget.fromJson(Map<String, Object?> json)
      : this(
      range: json['range']! as String,
      amount: json['amount']! as num,
      uuid: json['uuid']! as String);

  Map<String, Object?> toJson() {
    return {
      'range': range,
      'amount': amount,
      'uuid': uuid,
    };
  }

  @override
  String toString() {
    return "$uuid: $range budget: £$amount.";
  }
}

final fakeBudgetEntries = FirebaseFirestore.instance
    .collection('fake-budget')
    .withConverter<FakeBudget>(
    fromFirestore: (snapshots, _) => FakeBudget.fromJson(snapshots.data()!),
    toFirestore: (entry, _) => entry.toJson());

