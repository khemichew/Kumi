import 'package:app/models/card_options.dart';
import 'package:flutter/material.dart';
import 'package:app/config/style.dart';
import 'package:barcode_widget/barcode_widget.dart';

class MembershipBarcode extends StatelessWidget {
  const MembershipBarcode(
      {Key? key, required this.store, required this.barcode})
      : super(key: key);

  final CardOption store;
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
      return BarcodeWidget(barcode: Barcode.qrCode(), data: barcode);
    } else { // barcode
      return BarcodeWidget(barcode: Barcode.gs128(), data: barcode);
    }
  }

  Widget buttonTemplate(String title, VoidCallback onClickBehaviour, Color background) {
    return TextButton(
      onPressed: () {
        onClickBehaviour();
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: background,
            borderRadius: regularRadius,
            boxShadow: defaultBoxShadow),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: ordinaryStyle),
              const Icon(
                Icons.chevron_right,
                color: Colors.black,
              )
            ]),
      ),
    );
  }

  contentBox(context) {
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
                      //width: double.maxFinite,
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
          buttonTemplate("Store details", () {}, Colors.teal[200]!),
          buttonTemplate("Remove card", () {}, Colors.red[100]!)
        ],
      ),
    );
  }
}
