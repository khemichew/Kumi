import 'package:app/config/style.dart';
import 'package:app/models/fake_spend_record.dart';
import 'package:app/tabs/records/update_record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecordItem extends StatelessWidget {
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final FakeSpendRecord record;
  final DocumentReference<FakeSpendRecord> recordDocRef;

  const RecordItem({required this.record, required this.recordDocRef, Key? key}) : super(key: key);

  Widget receiptImage(FakeSpendRecord record) {
    return Dialog(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(record.url), fit: BoxFit.cover)),
      ),
    );
  }

  void updateRecordEntry(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UpdateRecord(record: record, recordDocRef: recordDocRef);
      }
    );
  }

  // Prompt the user to confirm before removing card entry
  void removeRecordEntry(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Remove record"),
              content: const Text(
                  "Are you sure you want to remove this record from your history?"),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    // Close confirmation dialog
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: const Text("Confirm"),
                  onPressed: () {
                    recordDocRef.delete();
                    // Close confirmation dialog
                    Navigator.pop(context);
                  },
                )
              ]);
        });
  }

  Widget get viewImageIndicator {
    return record.url == ""
        ? const Text("")
        : const Icon(Icons.keyboard_arrow_right,
            color: Colors.white);
  }

  Widget modifyRecordButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit, color: Colors.white),
      onPressed: () {
        updateRecordEntry(context);
      },
    );
  }

  Widget deleteRecordButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.redAccent),
      onPressed: () {
        removeRecordEntry(context);
      },
    );
  }

  // Provides indicator, edit and delete button
  Widget recordOperationsButtons(BuildContext context) {
    return Wrap(
        children: [viewImageIndicator, modifyRecordButton(context), deleteRecordButton(context)]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(64, 75, 96, .8)),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: const EdgeInsets.only(right: 12.0),
              decoration: const BoxDecoration(
                  border: Border(
                      right: BorderSide(width: 1.0, color: Colors.white24))),
              child: Text(
                "£${record.amount.toStringAsFixed(2)}",
                style: recordAmountStyle,
              ),
            ),
            title: Text(
              formatter.format(record.time),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle:
                Text(record.store, style: const TextStyle(color: Colors.white)),
            trailing: recordOperationsButtons(context),
            onTap: () {
              if (record.url != "") {
                showDialog(
                    context: context, builder: (_) => receiptImage(record));
              }
            },
          )),
    );
  }
}