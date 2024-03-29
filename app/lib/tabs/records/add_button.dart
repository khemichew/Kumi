import 'package:kumi/config/style.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../track/receipt_upload.dart';

class AddingShopForm extends StatefulWidget {
  const AddingShopForm({super.key});

  @override
  AddShoppingState createState() => AddShoppingState();
}

class AddShoppingState extends State<AddingShopForm> {
  DateTime selectedDate = DateTime.now();

  final storeController = TextEditingController(text: 'Tesco');
  final amountController = TextEditingController();
  final dateController = TextEditingController(text: DateTime.now().toString());

  ReceiptUpload receiptUpload = ReceiptUpload();

  String dropdownvalue = 'Tesco';

  var items = [
    'Tesco',
    'Sainsburys',
    'Waitrose',
    'Boots',
    'Holland & Barrette',
    'Mark & Spencer'
  ];

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    storeController.dispose();
    amountController.dispose();
    dateController.dispose();
    super.dispose();
  }

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

  Future<void> addShopping(String store, String amount, String date) async {
    await receiptUpload.uploadFile();
    Map<String, dynamic> data = receiptUpload.getImageURL() == "hello" ? {
      'store': store,
      'amount': amount,
      'time': Timestamp.fromDate(DateTime.parse(date))
    } : {
      'store': store,
      'amount': amount,
      'time': Timestamp.fromDate(DateTime.parse(date)),
      'receipt-image': receiptUpload.getImageURL(),
    };
    FirebaseFirestore.instance.collection("test-spend-record").add(data);
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController timeController) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        locale: const Locale("en", "EN"),
        initialDate: selectedDate,
        firstDate: DateTime(2010),
        lastDate: DateTime(2100));

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        timeController.text = selectedDate.toString();
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
                        storeController.text = newValue;
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
                    onPressed: () {
                      _selectDate(context, dateController);
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
                    addShopping(storeController.text, amountController.text,
                        dateController.text);
                  }
                  Navigator.pop(context);
                },
                child: Container(
                    width: 500,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: mintGreen,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 5.0),
                    child: const Text(
                      "Submit",
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