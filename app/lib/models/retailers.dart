import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
class Retailer {
  final String name;
  final String imageUrl;
  final String address;
  final num rating;

  const Retailer(
      {required this.name, required this.imageUrl, required this.address, required this.rating});

  Retailer.fromJson(Map<String, Object?> json)
      : this(
      name: json['name']! as String,
      imageUrl: json['imageUrl']! as String,
      address: json['address']! as String,
      rating: json['rating']! as num);

  Map<String, Object?> toJson() {
    return {'name': name, 'imageUrl': imageUrl, 'address': address, 'rating': rating};
  }
}

// Instance to database, referencing the list of retailers
// withConverter is used to ensure type-safety
final retailerEntries = FirebaseFirestore.instance
    .collection('retailer-example')
    .withConverter<Retailer>(
    fromFirestore: (snapshots, _) => Retailer.fromJson(snapshots.data()!),
    toFirestore: (entry, _) => entry.toJson());