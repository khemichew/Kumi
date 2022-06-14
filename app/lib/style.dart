import 'package:flutter/material.dart';
import 'dart:math';

const TextStyle optionStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black);

const TextStyle titleStyle =
    TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black);

const TextStyle ordinaryStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black);

Color getRandomPastelColour() {
    Color randomColour = Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    Color saturated = randomColour;
    Color white = Colors.white.withOpacity(0.3);
    return Color.alphaBlend(white, saturated);
}