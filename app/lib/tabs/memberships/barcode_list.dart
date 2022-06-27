import 'package:kumi/models/card_entries.dart';
import 'package:kumi/models/card_options.dart';
import 'package:kumi/config/style.dart';

import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MembershipBarcode extends StatelessWidget {
  const MembershipBarcode(
      {Key? key,
      required this.store,
      required this.storeDocId,
      required this.barcode})
      : super(key: key);

  final CardOption store;
  final DocumentReference<CardEntry> storeDocId;
  final String barcode;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: regularRadius,
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget get displayCode {
    if (store.type == CardType.qr) {
      // QR code
      return BarcodeWidget(barcode: Barcode.qrCode(), data: barcode);
    } else if (store.type == CardType.aztec) {
      // Aztec
      return BarcodeWidget(barcode: Barcode.aztec(), data: barcode);
    } else {
      // barcode
      return BarcodeWidget(barcode: Barcode.gs128(), data: barcode);
    }
  }

  Widget buttonTemplate(
      String title, VoidCallback onClickBehaviour, Color background) {
    return TextButton(
      onPressed: onClickBehaviour,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: background,
            borderRadius: regularRadius,
            boxShadow: defaultBoxShadow),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title, style: ordinaryStyle),
          const Icon(
            Icons.chevron_right,
            color: Colors.black,
          )
        ]),
      ),
    );
  }

  // Prompt the user to confirm before removing card entry
  void removeCardEntry(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Remove card entry"),
              content: Text(
                  "Are you sure you want to remove ${store.name} card entry from the wallet?"),
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
                    storeDocId.delete();
                    // Close confirmation dialog and barcode dialog
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ]);
        });
  }

  dynamic contentBox(context) {
    return SizedBox(
      height: 400,
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
                borderRadius: regularRadius,
                boxShadow: defaultBoxShadow),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.67,
                      child: displayCode),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                        color: honeyOrange,
                        borderRadius: regularRadius,
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          store.name,
                          style: ordinaryStyle,
                          textAlign: TextAlign.center,
                        ),
                      )),
                ]),
          ),
          // buttonTemplate("Store details", () {}, Colors.teal[200]!),
          buttonTemplate("Remove card", () {
            removeCardEntry(context);
          }, Colors.red[100]!)
        ],
      ),
    );
  }
}
