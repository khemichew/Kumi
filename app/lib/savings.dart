import 'package:flutter/material.dart';
import 'package:app/style.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class SavingsPage extends StatelessWidget {
  const SavingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 80, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: const Text(
              "You have saved:",
              style: largeTitleStyle,
            ),
          ),
        ],
      ),
    );
  }
}