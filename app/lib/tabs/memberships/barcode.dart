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
        borderRadius: BorderRadius.circular(10.0),
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
                    //width: double.maxFinite,
                      width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10)),
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
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(53, 219, 169, 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
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