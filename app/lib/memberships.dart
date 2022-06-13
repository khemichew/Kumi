import 'package:flutter/material.dart';
import 'package:app/style.dart';
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
              decoration:BoxDecoration(
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
        onPressed: () {  },
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