import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
class FakeUser {
  final String avatar;
  final String emailAddress;
  // final List<Map<String, String>> memberships;
  final String name;
  final int phoneNumber;
  // final List<Map<String, Object?>> savings;
  final String uuid;


  const FakeUser(
      {required this.avatar,
        required this.emailAddress,
        // required this.memberships,
        required this.name,
        required this.phoneNumber,
        // required this.savings,
        required this.uuid});

  FakeUser.fromJson(Map<String, Object?> json)
      : this(
      avatar: json['avatar']! as String,
      emailAddress: json['emailAddress']! as String,
      // memberships: json['memberships']! as List<Map<String, String>>,
      name: json['name']! as String,
      phoneNumber: json['phoneNumber']! as int,
      // savings: json['savings']! as List<Map<String, Object?>>,
      uuid: json['uuid']! as String);

  Map<String, Object?> toJson() {
    return {
      'avatar': avatar,
      'emailAddress': emailAddress,
      // 'memberships': memberships,
      'name': name,
      'phoneNumber': phoneNumber,
      // 'savings': savings,
      'uuid': uuid,
    };
  }

  @override
  String toString() {
    return "$name $emailAddress";
  }
}

final fakeUserEntries = FirebaseFirestore.instance
    .collection('test-users')
    .withConverter<FakeUser>(
    fromFirestore: (snapshots, _) => FakeUser.fromJson(snapshots.data()!),
    toFirestore: (entry, _) => entry.toJson());

