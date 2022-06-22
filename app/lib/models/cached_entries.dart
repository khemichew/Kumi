import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CachedEntries<T> extends ChangeNotifier {
  static const Duration validity = Duration(minutes: 30);

  CollectionReference<T> databaseInstance;
  final Duration _cacheValidDuration = validity;
  final DateTime _lastFetchTime = DateTime.fromMillisecondsSinceEpoch(0);
  Map<String, T> _records = {};

  CachedEntries({required this.databaseInstance});

  Future<void> _updateEntries() async {
    final snapshot = await databaseInstance.get();
    _records = { for (var v in snapshot.docs) v.id : v.data() };
    notifyListeners();
  }

  bool _shouldUpdate() {
    return _lastFetchTime.isBefore(DateTime.now().subtract(_cacheValidDuration));
  }

  // Return a mapping of documentID to entries in the database
  Future<Map<String, T>> getAllRecords({bool forceUpdate = false}) async {
    bool shouldRefreshData = (_records.isEmpty || _shouldUpdate() || forceUpdate);

    if (shouldRefreshData) {
      await _updateEntries();
    }

    return _records;
  }
}