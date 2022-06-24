import 'package:app/models/fake_spend_record.dart';
import 'package:app/config/style.dart';
import 'package:app/tabs/records/add_button.dart';
import 'package:app/tabs/records/record_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'add_button.dart';

class Record extends StatelessWidget {
  const Record({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return RecordList();
    return Scaffold(
      appBar: AppBar(
//        backgroundColor: Colors.transparent,
        backgroundColor: const Color(0x44000000),
        elevation: 0,
        title: const Text(
          "Records",
          style: titleStyle,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: const Expanded(child: RecordList()),
      ),
      floatingActionButton: generateAddButton(context),
    );
  }
}

Container generateAddButton(BuildContext context) {
  return Container(
    alignment: Alignment.bottomRight,
    child: FloatingActionButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AddingShopForm();
            });
      },
      backgroundColor: const Color.fromRGBO(53, 219, 169, 1.0),
      child: const Icon(Icons.add),
    ),
  );
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

          return ListView.builder(
            itemCount: data.docs.length,
            itemBuilder: (context, index) {
              final record = data.docs[index];
              return RecordItem(record: record.data(), recordDocRef: record.reference);
            },
          );
        });
  }
}


