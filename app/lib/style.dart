import 'package:flutter/material.dart';

const TextStyle optionStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black);

const TextStyle titleStyle =
    TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black);

const TextStyle ordinaryStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black);

const BoxDecoration gradientBackground = BoxDecoration(
    gradient: LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [
    Color.fromRGBO(173, 190, 216, 1),
    Color.fromRGBO(255, 229, 205, 1),
  ],
));
