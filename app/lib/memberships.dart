import 'package:flutter/material.dart';
import 'package:app/style.dart';
import 'package:barcode_widget/barcode_widget.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class MembershipPage extends StatelessWidget {
  const MembershipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 50, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const MembershipPageHead(),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                MembershipCard(storeName: 'Store A', color: Color.fromRGBO(255, 191, 0, 0.5),),
                MembershipCard(storeName: 'Store B', color: Color.fromRGBO(248, 152, 128, 0.5),),
              ]
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                MembershipCard(storeName: 'Store C', color: Color.fromRGBO(137, 207, 240, 0.5),),
                MembershipCard(storeName: 'Store D', color: Color.fromRGBO(115, 113, 255, 0.5),),
              ]
          ),
        ],
      ),
    );
  }
}

class MembershipPageHead extends StatelessWidget {
  const MembershipPageHead({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
          child:TextButton(
            onPressed: () {  },
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black
                  ),
                  color: Colors.white38,
                  borderRadius: const BorderRadius.all(Radius.circular(10))
              ),
              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Add", style: ordinaryStyle),
                  Icon(Icons.add, color: Colors.black,)
                ],
              ),
            ),
          ),
        ),
      ]
    );
  }
}

class MembershipCard extends StatelessWidget {
  const MembershipCard({Key? key, required this.storeName, required this.color}) : super(key: key);

  final String storeName;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return MembershipBarcode(
                storeName: storeName,
                color: color,
              );
            }
          );
        },
        child: Container(
          height: 100,
          decoration:BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(10))
          ),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(storeName, style: ordinaryStyle),
                    const Icon(Icons.chevron_right, color: Colors.black,)
                  ]
              ),
              // const Icon(Icons.card_membership)
            ],
          ),
        ),
      ),
    );
  }
}

class MembershipBarcode extends StatelessWidget {
  MembershipBarcode({Key? key, required this.storeName, required this.color}) : super(key: key);

  final String storeName;
  final Color color;

  // Create a DataMatrix barcode
  final dm = Barcode.dataMatrix();

// Generate a SVG with "Hello World!"
//   final svg = bc.toSvg('Hello World!', width: 200, height: 200);

// Save the image
//   await File('barcode.svg').writeAsString(svg);

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
              boxShadow: defaultBoxShadow
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // const Image(image: AssetImage('assets/dingzhen_cute.jpeg')),
                BarcodeWidget(
                  // Nectar - Khemi
                  barcode: Barcode.gs128(),
                  data: '${appIdMap['nectar']!}1234567890',
                ),
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: color,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: Text('$storeName card', style: ordinaryStyle, textAlign: TextAlign.center,),
                ),
              ]
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Container(
              height: 50,
              decoration:const BoxDecoration(
                  color: Color.fromRGBO(53, 219, 169, 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: defaultBoxShadow
              ),
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Deals & rewards', style: ordinaryWhiteStyle),
                  Icon(Icons.chevron_right, color: Colors.white,)
                ]
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black
                  ),
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: defaultBoxShadow
              ),
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Store details', style: ordinaryStyle),
                  Icon(Icons.chevron_right, color: Colors.black,)
                ]
              ),
            ),
          ),
        ],
      ),
    );
  }
  
}