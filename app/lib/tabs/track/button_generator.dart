import 'package:app/tabs/track/landing_page.dart';
import 'package:flutter/material.dart';
import '../../config/style.dart';

class ButtonGenerator extends StatelessWidget {
  final String text;
  final RecordQuery queryType;
  final BudgetType budgetType;
  final void Function(RecordQuery, BudgetType) notifyParent;

  const ButtonGenerator(
      {super.key,
        required this.text,
        required this.notifyParent,
        required this.queryType,
      required this.budgetType});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // print("Im pressed");
        notifyParent(queryType, budgetType);
      },
      style: ElevatedButton.styleFrom(
        primary: honeyOrange,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: navyBlue),
          borderRadius: BorderRadius.all(Radius.circular(10))
        )
      ),
      child: Text(
        text,
        style: smallStyle.copyWith(color: Colors.black),
      ),
    );
  }
}