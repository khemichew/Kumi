import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/config/style.dart';
import 'package:app/tabs/memberships/barcode.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../../models/retailers.dart';

class MembershipPage extends StatelessWidget {
  const MembershipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 50, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [MembershipPageHead(), Flexible(child: MembershipList())],
      ),
    );
  }
}

class MembershipPageHead extends StatefulWidget {
  const MembershipPageHead({Key? key}) : super(key: key);

  @override
  State<MembershipPageHead> createState() => _MembershipPageHeadState();
}

class _MembershipPageHeadState extends State<MembershipPageHead> {
  // String _scanBarcode = "Unknown";

  Future<void> scanBarcode() async {
    await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE
    );
    // print("$barcode");
    // TODO: add entry to database

    // setState(() {
    //   _scanBarcode = barcode;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            padding: verticalTenInsets,
            child: const Text(
              'My\nmemberships',
              style: titleStyle,
            ),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: scanBarcode,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.white38,
                  borderRadius: regularRadius
              ),
              padding: verticalTenInsets,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Add", style: ordinaryStyle),
                  Icon(
                    Icons.add,
                    color: Colors.black,
                  )
                ],
              ),
            ),
          ),
        ),
      ]
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

          return Flexible(
              child: GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(data.size, (index) {
                    final docRef = data.docs[index];
                    return Center(
                        child: MembershipCard(docRef.data(), docRef.reference));
                  })));
        });
  }
}

class MembershipCard extends StatelessWidget {
  final Retailer retailer;
  final DocumentReference<Retailer> reference;

  const MembershipCard(this.retailer, this.reference, {Key? key})
      : super(key: key);

  Widget get title {
    return Text(retailer.name,
        style: ordinaryStyle,
        overflow: TextOverflow.fade,
        maxLines: 2,
        softWrap: false);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return MembershipBarcode(
                  storeName: retailer.name,
                  color: honeyOrange
              );
            });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(retailer.imageUrl), fit: BoxFit.cover),
            borderRadius: regularRadius
        ),
        padding: allSidesTenInsets,
      ),
    );
  }
}
