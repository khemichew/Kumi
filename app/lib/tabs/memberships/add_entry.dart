import 'package:app/models/cached_entries.dart';
import 'package:app/models/retailers.dart';
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

  Future<void> scanBarcode() async {
    String result;
    try {
      result = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE
      );
    } on PlatformException {
      result = failState;
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CachedEntries<Retailer>>(
      builder: (context, entries, child) {
        return const SimpleDialog(
          title: Text("Add new entry"),
          children: [
          ]
        );
      }
    );
  }
}
