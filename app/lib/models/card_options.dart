import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum CardType { barcode, qr }

@immutable
class CardOption {
  final String name;
  final String imageUrl;
  final CardType type;

  const CardOption({required this.name, required this.imageUrl, required this.type});

  CardOption.fromJson(Map<String, Object?> json)
      : this(
            name: json['name']! as String,
            imageUrl: json['imageUrl']! as String,
            type: CardType.values.firstWhere(
                (entry) => describeEnum(entry) == json['cardType']));

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'cardType': type.toString()
    };
  }
}

// Instance to database, referencing the list of retailers
// withConverter is used to ensure type-safety
final cardOptions = FirebaseFirestore.instance
    .collection('cards')
    .withConverter<CardOption>(
        fromFirestore: (snapshots, _) => CardOption.fromJson(snapshots.data()!),
        toFirestore: (entry, _) => entry.toJson());
