import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
class FakeSpendRecord {
  final String store;
  final num amount;
  final DateTime timestamp;

  const FakeSpendRecord(
      {required this.store,
      required this.amount,
      required this.timestamp,});

  FakeSpendRecord.fromJson(Map<String, Object?> json)
      : this(
      store: json['store']! as String,
      amount: json['amount']! as num,
      timestamp: json['timestamp']! as DateTime);

  Map<String, Object?> toJson() {
    return {
      'store': store,
      'amount': amount,
      'timestamp': timestamp
    };
  }

  @override
  String toString() {
    return "$timestamp $store $amount";
  }
}

final fakeSpendRecordEntries = FirebaseFirestore.instance
    .collection('test-spend-record')
    .withConverter<FakeSpendRecord>(
        fromFirestore: (snapshots, _) => FakeSpendRecord.fromJson(snapshots.data()!),
        toFirestore: (entry, _) => entry.toJson());

