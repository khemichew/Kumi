import 'package:app/models/cached_entries.dart';
import 'package:app/models/card_entries.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/config/style.dart';
import 'package:app/tabs/memberships/barcode_list.dart';
import 'package:app/models/card_options.dart';
import 'package:app/tabs/memberships/add_entry.dart';
import 'package:provider/provider.dart';

class MembershipPage extends StatelessWidget {
  const MembershipPage({Key? key}) : super(key: key);

  AppBar get titleBar {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text("Cards", style: titleStyle),
    );
  }

  dynamic addButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AddMembershipDialog();
            })
      },
      backgroundColor: mintGreen,
      child: const Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: titleBar,
      body: const MembershipList(),
      floatingActionButton: addButton(context),
    );
  }
}

class MembershipList extends StatefulWidget {
  const MembershipList({Key? key}) : super(key: key);

  @override
  State<MembershipList> createState() => _MembershipListState();
}

class _MembershipListState extends State<MembershipList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<CardEntry>>(
        stream: cardEntries.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;

          if (data.size == 0) {
            return const Center(
              child: Text("Keep all the store cards you use every day, all in one place.")
            );
          }

          return GridView.count(
              childAspectRatio: 3 / 2,
              crossAxisCount: 2,
              children: List.generate(
                data.size,
                (index) {
                  final docRef = data.docs[index];
                  return Center(
                      child: MembershipCard(docRef.data(), docRef.reference));
                },
              ));
        });
  }
}

class MembershipCard extends StatelessWidget {
  final CardEntry cardEntry;
  final DocumentReference<CardEntry> reference;

  const MembershipCard(this.cardEntry, this.reference, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CachedEntries<CardOption>>(
        builder: (context, entries, child) {
      return FutureBuilder<Map<String, CardOption>>(
          future: entries.getAllRecords(),
          builder: (context, snapshot) {
            final cardOption = snapshot.requireData[cardEntry.cardOptionId];
            return TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return MembershipBarcode(
                        store: cardOption!,
                        barcode: cardEntry.barcode);
                  },
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(cardOption!.imageUrl),
                        fit: BoxFit.cover),
                    borderRadius: regularRadius,
                    border: Border.all(color: Colors.black)),
                padding: allSidesTenInsets,
              ),
            );
          });
    });
  }
}
