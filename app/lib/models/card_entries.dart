import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
class CardEntry {
  final String cardOptionId;
  final String barcode;

  const CardEntry({required this.cardOptionId, required this.barcode});

  CardEntry.fromJson(Map<String, dynamic> json)
      : this(
            cardOptionId: json['cardOptionId'] as String,
            barcode: json['barcode'] as String);

  Map<String, dynamic> toJson() {
    return {'cardOptionId': cardOptionId, 'barcode': barcode};
  }
}

final cardEntries = FirebaseFirestore.instance
    .collection('card-entries')
    .withConverter<CardEntry>(
    fromFirestore: (snapshots, _) => CardEntry.fromJson(snapshots.data()!),
    toFirestore: (entry, _) => entry.toJson());
