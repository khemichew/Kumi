import 'package:kumi/models/fake_spend_record.dart';
import 'package:kumi/config/style.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../track/receipt_upload.dart';

class UpdateRecord extends StatefulWidget {
  final FakeSpendRecord record;
  final DocumentReference<FakeSpendRecord> recordDocRef;

  const UpdateRecord({required this.record, required this.recordDocRef, super.key});

  @override
  UpdateRecordState createState() => UpdateRecordState();
}

class UpdateRecordState extends State<UpdateRecord> {
  DateTime selectedDate = DateTime.now();

  final amountController = TextEditingController();

  String defaultAmount = '0';
  String defaultDate = DateTime.now().toString();

  ReceiptUpload receiptUpload = ReceiptUpload();

  String dropdownvalue = "";

  var items = [
    'Tesco',
    'Sainsbury\'s',
    'Waitrose',
    'Boots',
    'Holland & Barrette',
    'Marks & Spencer',
    'Co-op',
    'Argos'
  ];

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    amountController.text = widget.record.amount.toString();
    dropdownvalue = dropdownvalue == "" ? widget.record.store : dropdownvalue;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Future<void> updateShopping(String store, String amount, String date) async {
    await receiptUpload.uploadFile();

    final String newUrl = receiptUpload.getImageURL();
    String url = '';
    bool updateUrl;

    if (newUrl == 'hello') {
      if (widget.record.url == '') {
        updateUrl = false;
      } else {
        updateUrl = true;
        url = widget.record.url;
      }
    } else {
      updateUrl = true;
      url = newUrl;
    }

    Map<String, dynamic> data = updateUrl ? {
      'store': store,
      'amount': amount,
      'time': DateTime.parse(date),
      'receipt-image': url
    } : {
      'store': store,
      'amount': amount,
      'time': DateTime.parse(date)
    };

    await widget.recordDocRef.update(data);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        locale: const Locale("en", "EN"),
        initialDate: selectedDate,
        firstDate: DateTime(2010),
        lastDate: DateTime(2100));

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  contentBox(context) {
    return Container(
        height: 300,
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: defaultBoxShadow),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Store:",
                  style: ordinaryStyle,
                ),
                SizedBox(
                  width: 160,
                  height: 40,
                  child: DropdownButton(
                    // Initial Value
                    value: dropdownvalue,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ),
                //Text((storeController.text))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Amount:", style: ordinaryStyle),
                quadSpacing,
                const Text(" £ ", style: ordinaryStyle),
                Container(
                  width: 120,
                  height: 40,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.0),
                    color: Colors.white,
                    borderRadius: regularRadius,
                  ),
                  alignment: Alignment.center,
                  child: TextField(
                    style: ordinaryStyle,
                    controller: amountController,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Date:",
                  style: ordinaryStyle,
                ),
                Container(
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.white,
                    borderRadius: regularRadius,
                  ),
                  child: TextButton(
                    onPressed: () async {
                      await _selectDate(context);
                    },
                    child: Text("${selectedDate.toLocal()}".split(' ')[0]),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            receiptUpload.build(context),

            TextButton(
                onPressed: () {
                  if (double.tryParse(amountController.text) != null) {
                    updateShopping(dropdownvalue, amountController.text,
                        selectedDate.toLocal().toString());
                  }
                  Navigator.pop(context);
                },
                child: Container(
                    height: 40,
                    width: 500,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: mintGreen,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    child: const Text(
                      "Update",
                      style: ordinaryStyle,
                      textAlign: TextAlign.center,
                    )
                )
            )
          ],
        )
    );
  }
}