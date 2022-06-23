import 'package:app/models/fake_spend_record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Record extends StatelessWidget {
  const Record({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RecordList();
  }
}

class RecordList extends StatefulWidget {
  const RecordList({Key? key}) : super(key: key);

  @override
  State<RecordList> createState() => _RecordListState();
}

class _RecordListState extends State<RecordList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<FakeSpendRecord>>(
        stream: fakeSpendRecordEntries
            .orderBy("time", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // error checking
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Loading..."));
          }

          final data = snapshot.requireData;

          final List<FakeSpendRecord> history =
              data.docs.map((e) => e.data()).toList();

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 8.0,
                margin:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Container(
                    decoration:
                        const BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      leading: Container(
                        padding: const EdgeInsets.only(right: 12.0),
                        decoration: const BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    width: 1.0, color: Colors.white24))),
                        child: Text(
                            "£${history[index].amount.toStringAsFixed(0)}"),
                      ),
                      title: Text(
                        DateFormat('yyyy-MM-dd').format(history[index].time),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(history[index].store,
                          style: const TextStyle(color: Colors.white)),
                      trailing: history[index].url == ""
                          ? const Text("")
                          : const Icon(Icons.keyboard_arrow_right,
                              color: Colors.white, size: 30.0),
                      onTap: () {if (history[index].url != "")  ReceiptImage().build(context, history[index].url);
                      },
                    )),
              );
            },
          );
        });
  }
}

class ReceiptImage {
  Widget build(BuildContext context, String url) {
    return Dialog(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
            image:
                DecorationImage(image: NetworkImage(url), fit: BoxFit.cover)),
      ),
    );
  }
}
