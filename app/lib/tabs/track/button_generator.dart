import 'package:app/tabs/track/landing_page.dart';
import 'package:flutter/material.dart';
import '../../config/style.dart';

class ButtonGenerator extends StatelessWidget {
  final String text;
  final RecordQuery queryType;
  final void Function(RecordQuery) notifyParent;

  const ButtonGenerator(
      {super.key,
        required this.text,
        required this.notifyParent,
        required this.queryType});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: outlineButtonStyle,
      onPressed: () {
        // print("Im pressed");
        notifyParent(queryType);
      },
      child: Text(
        text,
        style: filterStyle,
      ),
    );
  }
}