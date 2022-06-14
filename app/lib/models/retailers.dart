import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
class Retailer {
  final String name;
  final int retailerId;
  final String description;
  final int rating;

  const Retailer(
      {required this.name, required this.retailerId, required this.description, required this.rating});

  Retailer.fromJson(Map<String, Object?> json)
      : this(
      name: json['name']! as String,
      retailerId: json['retailerId']! as int,
      description: json['description']! as String,
      rating: json['rating']! as int);

  Map<String, Object?> toJson() {
    return {'name': name, 'description': description, 'rating': rating};
  }
}

// Instance to database, referencing the list of retailers
// withConverter is used to ensure type-safety
final retailerEntries = FirebaseFirestore.instance
    .collection('retailers')
    .withConverter<Retailer>(
    fromFirestore: (snapshots, _) => Retailer.fromJson(snapshots.data()!),
    toFirestore: (entry, _) => entry.toJson());

// The different ways we can sort/filter entries
enum RetailerQuery { nameAsc, nameDesc, ratingAsc, ratingDesc }

// extension on Query<Retailer> {
//   // Create a firebase query from a [RetailerQuery]
//   Query<Retailer> queryBy(RetailerQuery query) {
//     switch (query) {
//       case RetailerQuery.nameAsc:
//       case RetailerQuery.nameDesc:
//         return orderBy('name', descending: query == RetailerQuery.nameDesc);
//       case RetailerQuery.ratingAsc:
//       case RetailerQuery.ratingDesc:
//         return orderBy('rating', descending: query == RetailerQuery.ratingDesc);
//     }
//   }
// }