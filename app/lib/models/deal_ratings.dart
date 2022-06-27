import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class DealRating {
  final String dealId;
  final String userId;
  final num rating;

  const DealRating(
      {required this.dealId, required this.userId, required this.rating});

  DealRating.fromJson(Map<String, dynamic> json)
      : this(
            dealId: json['dealId'] as String,
            userId: json['userId'] as String,
            rating: json['rating'] as num);

  Map<String, dynamic> toJson() {
    return {'dealId': dealId, 'userId': userId, 'rating': rating};
  }
}

final dealRatingEntries = FirebaseFirestore.instance
    .collection('deal_ratings')
    .withConverter<DealRating>(
        fromFirestore: (snapshots, _) => DealRating.fromJson(snapshots.data()!),
        toFirestore: (entry, _) => entry.toJson());
