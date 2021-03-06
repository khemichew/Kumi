import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../config/style.dart';
import '../../models/fake_budget.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class BudgetView extends StatefulWidget {
  const BudgetView({super.key});

  @override
  BudgetViewState createState() => BudgetViewState();
}

class BudgetViewState extends State<BudgetView> {
  final yearlyController = TextEditingController();
  final monthlyController = TextEditingController();
  final weeklyController = TextEditingController();
  late String yearlyID;
  late String monthlyID;
  late String weeklyID;

  String yearlyBudget() {
    return yearlyController.text;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    yearlyController.dispose();
    monthlyController.dispose();
    weeklyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          height: 230,
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: defaultBoxShadow),
          child: StreamBuilder<QuerySnapshot<FakeBudget>>(
              stream: fakeBudgetEntries
                  .where("uuid", isEqualTo: "123456")
                  .snapshots(),
              builder: (context, snapshot) {
                // error checking
                if (snapshot.hasError) {
                  return const Center(child: Text("Something went wrong"));
                }

                if (!snapshot.hasData) {
                  return const Center(child: Text("No entries found"));
                }

                final data = snapshot.requireData;

                final List<FakeBudget> budgets =
                    data.docs.map((e) => e.data()).toList();

                yearlyID = data.docs.where((element) => element.data().range == "yearly").first.id;
                monthlyID = data.docs.where((element) => element.data().range == "monthly").first.id;
                weeklyID = data.docs.where((element) => element.data().range == "weekly").first.id;

                yearlyController.text = budgets
                    .where((e) => e.range == "yearly")
                    .first
                    .amount
                    .toString();
                monthlyController.text = budgets
                    .where((e) => e.range == "monthly")
                    .first
                    .amount
                    .toString();
                weeklyController.text = budgets
                    .where((e) => e.range == "weekly")
                    .first
                    .amount
                    .toString();

                return Align(
                  alignment: Alignment.center,
                  child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        showBudget(budgets, "yearly", yearlyController),
                        showBudget(budgets, "monthly", monthlyController),
                        showBudget(budgets, "weekly", weeklyController),
                        showUpdateBudget()
                      ]),
                );
              }),
        ));
  }

  Widget showBudget(List<FakeBudget> budgets, String range,
      TextEditingController controller) {
    // FakeBudget budget = budgets.where((e) => e.range == range).first;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${range.toTitleCase()} budget:",
            style: ordinaryStyle,
          ),
          SizedBox(
            width: 80,
            height: 40,
            child: TextFormField(
              style: ordinaryStyle,
              textAlign: TextAlign.end,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                border: OutlineInputBorder(),
              ),
              controller: controller,
            ),
          )
        ]);
  }

  Widget showUpdateBudget() {
    return Center(
        child: TextButton(
            onPressed: () {
              updateBudget(yearlyController.text, monthlyController.text, weeklyController.text);
              Navigator.pop(context);
            },
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: mintGreen,
                  borderRadius: regularRadius,
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 5.0, horizontal: 5.0),
                child: const Text(
                  "Update",
                  style: ordinaryStyle,
                  textAlign: TextAlign.center,
                )
            )
        ));
  }

  void updateBudget(String yearBudget, String monthBudget, String weekBudget) {
    FirebaseFirestore.instance.collection("fake-budget").doc(yearlyID).update({
      'amount': double.parse(yearBudget),
    });
    FirebaseFirestore.instance.collection("fake-budget").doc(monthlyID).update({
      'amount': double.parse(monthBudget),
    });
    FirebaseFirestore.instance.collection("fake-budget").doc(weeklyID).update({
      'amount': double.parse(weekBudget),
    });
  }
}