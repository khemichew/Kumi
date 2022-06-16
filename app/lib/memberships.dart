import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/style.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'models/retailers.dart';

class MembershipPage extends StatelessWidget {
  const MembershipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 50, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [MembershipPageHead(), MembershipList()],
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
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
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
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            padding:
            const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
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
    ]);
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
                  color: const Color.fromRGBO(255, 191, 0, 0.5));
            });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(retailer.imageUrl), fit: BoxFit.cover),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(child: title),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.black,
                )
              ]),
            ]),
      ),
    );
  }
}

class MembershipBarcode extends StatelessWidget {
  MembershipBarcode({Key? key, required this.storeName, required this.color})
      : super(key: key);

  final String storeName;
  final Color color;

  // Create a DataMatrix barcode
  final dm = Barcode.dataMatrix();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return SizedBox(
      height: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 200,
            margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: defaultBoxShadow),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.67,
                      child: BarcodeWidget(
                        // Nectar - Khemi
                        barcode: Barcode.gs128(),
                        data: '${appIdMap['nectar']!}1234567890',
                      )),
                  Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          '$storeName card',
                          style: ordinaryStyle,
                          textAlign: TextAlign.center,
                        ),
                      )),
                ]),
          ),
          TextButton(
            onPressed: () {},
            child: Container(
              height: 50,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(53, 219, 169, 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: defaultBoxShadow),
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Deals & rewards', style: ordinaryWhiteStyle),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    )
                  ]),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: defaultBoxShadow),
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Store details', style: ordinaryStyle),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                    )
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
