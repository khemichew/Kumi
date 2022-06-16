import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
class FakeSpendRecord {
  final String store;
  final num amount;
  final DateTime time;

  const FakeSpendRecord({
    required this.store,
    required this.amount,
    required this.time,
  });

  FakeSpendRecord.fromJson(Map<String, dynamic> json)
      : this(
            store: json['store']! as String,
            amount: num.parse(json['amount']),
            time: (json['time'] as Timestamp).toDate());

  Map<String, Object?> toJson() {
    return {'store': store, 'amount': amount, 'time': time};
  }

  @override
  String toString() {
    return "$time $store $amount";
  }
}

final fakeSpendRecordEntries = FirebaseFirestore.instance
    .collection('test-spend-record')
    .withConverter<FakeSpendRecord>(
        fromFirestore: (snapshots, _) =>
            FakeSpendRecord.fromJson(snapshots.data()!),
        toFirestore: (entry, _) => entry.toJson());
