import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/config/style.dart';
import 'package:app/tabs/memberships/barcode_list.dart';
import 'package:app/models/retailers.dart';
import 'package:app/tabs/memberships/add_entry.dart';

class MembershipPage extends StatelessWidget {
  const MembershipPage({Key? key}) : super(key: key);

  AppBar get titleBar {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text("My memberships", style: titleStyle),
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
      extendBodyBehindAppBar: true,
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
    return StreamBuilder<QuerySnapshot<Retailer>>(
        stream: retailerEntries.orderBy('name').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;

          return GridView.count(
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
  final Retailer retailer;
  final DocumentReference<Retailer> reference;

  const MembershipCard(this.retailer, this.reference, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return MembershipBarcode(
                  storeName: retailer.name, color: honeyOrange);
            });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(retailer.imageUrl), fit: BoxFit.cover),
            borderRadius: regularRadius,
            border: Border.all(color: Colors.black)),
        padding: allSidesTenInsets,
      ),
    );
  }
}
