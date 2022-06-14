import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

const TextStyle titleStyle =
    TextStyle(fontSize: 23, fontWeight: FontWeight.w500, color: Colors.black);

const TextStyle emphStyle =
TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black);

const TextStyle largeTitleStyle =
TextStyle(fontSize: 32, fontWeight: FontWeight.w500, color: Colors.black);

const TextStyle ordinaryStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black);

const TextStyle smallStyle =
TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black);

const TextStyle hugeStyle =
TextStyle(fontSize: 50, fontWeight: FontWeight.w500, color: Colors.black);

const TextStyle ordinaryWhiteStyle =
TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white);

const defaultBoxShadow = [
    BoxShadow(
        color: Colors.black,
        offset: Offset(0, 5),
        blurRadius: 5
    ),
];


Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/config.json');
}