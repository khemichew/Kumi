import 'package:flutter/material.dart';
import 'package:app/config/style.dart';
import 'package:barcode_widget/barcode_widget.dart';

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
        borderRadius: regularRadius,
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
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
                      child: BarcodeWidget(
                        // Nectar - Khemi
                        barcode: Barcode.gs128(),
                        data: '${appIdMap['nectar']!}1234567890',
                      )),
                  Container(
                    //width: double.maxFinite,
                      width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: regularRadius,
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '$storeName barcode',
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
              decoration: BoxDecoration(
                  color: mintGreen,
                  borderRadius: regularRadius,
                  boxShadow: defaultBoxShadow),
              padding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Deals', style: ordinaryWhiteStyle),
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
                  borderRadius: regularRadius,
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