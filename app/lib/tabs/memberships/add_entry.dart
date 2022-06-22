import 'package:app/models/cached_entries.dart';
import 'package:app/models/card_options.dart';
import 'package:app/models/card_entries.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

class AddMembershipDialog extends StatefulWidget {
  const AddMembershipDialog({Key? key}) : super(key: key);

  @override
  State<AddMembershipDialog> createState() => _AddMembershipDialogState();
}

class _AddMembershipDialogState extends State<AddMembershipDialog> {
  static const String failState = "FAIL";
  String _scanBarcode = failState;

  Future<void> scanBarcode(ScanMode mode) async {
    String result;
    try {
      result = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, mode);
    } on PlatformException {
      result = failState;
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = result;
    });
  }

  List<Widget> generateCardOptions(Map<String, CardOption> cards) {
    return cards.entries.map((entry) {
      final id = entry.key;
      final card = entry.value;
      return SimpleDialogOption(
          child: Text(card.name),
        onPressed: () {
            ScanMode mode;
            if (card.type == CardType.qr) {
              mode = ScanMode.QR;
            } else {
              mode = ScanMode.BARCODE;
            }

            // Retrieve barcode
            scanBarcode(mode);

            // Add entry to database
            if (_scanBarcode != failState) {
              CardEntry cardEntry = CardEntry(cardOptionId: id, barcode: _scanBarcode);
              cardEntries.add(cardEntry);
            }

            // Close options list
            Navigator.pop(context);
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CachedEntries<CardOption>>(
        builder: (context, entries, child) {
      return FutureBuilder<Map<String, CardOption>>(
          future: entries.getAllRecords(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return AlertDialog(
                  title: const Text("Something went wrong"),
                  content: Text("Error: ${snapshot.error}"));
            }

            if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const AlertDialog(title: Text("No available options!"));
            }

          // Return list of card options
            final cardOptions = snapshot.requireData;

            return SimpleDialog(
                title: const Text("Add store cards"),
                children: generateCardOptions(cardOptions));
          });
    });
  }
}
