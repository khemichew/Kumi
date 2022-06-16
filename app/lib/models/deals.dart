import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
class Deal {
  final String name;
  final String description;
  final String retailerId;
  final num retailPrice;
  final num discountedPrice;

  const Deal(
      {required this.name,
      required this.description,
      required this.retailerId,
      required this.retailPrice,
      required this.discountedPrice});

  Deal.fromJson(Map<String, Object?> json)
      : this(
            name: json['name']! as String,
            description: json['description']! as String,
            retailerId: json['retailerId']! as String,
            retailPrice: json['retailPrice']! as num,
            discountedPrice: json['discountedPrice']! as num);

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'description': description,
      'retailerId': retailerId,
      'retailPrice': retailPrice,
      'discountedPrice': discountedPrice
    };
  }

  @override
  String toString() {
    return "$name $description $retailerId $retailPrice $discountedPrice";
  }
}

final dealEntries = FirebaseFirestore.instance
    .collection('fake-deals')
    .withConverter<Deal>(
        fromFirestore: (snapshots, _) => Deal.fromJson(snapshots.data()!),
        toFirestore: (entry, _) => entry.toJson());
