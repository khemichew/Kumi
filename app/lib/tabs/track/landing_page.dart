import 'package:kumi/models/fake_budget.dart';
import 'package:kumi/models/fake_spend_record.dart';
import 'package:kumi/config/style.dart';
import 'package:kumi/tabs/track/budget.dart';
import 'package:kumi/tabs/track/button_generator.dart';
import 'package:kumi/tabs/track/generate_chart.dart';
import 'package:kumi/tabs/records/add_button.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

enum RecordQuery {
  showDescendingData,
  all,
  year,
  month,
  week,
}

extension on Query<FakeSpendRecord> {
  Query<FakeSpendRecord> queryBy(RecordQuery query) {
    switch (query) {
      case RecordQuery.showDescendingData:
        return orderBy("time", descending: true);

      case RecordQuery.all:
        return orderBy("time", descending: false);

      case RecordQuery.year:
        return where("time",
            isGreaterThan: (Timestamp.fromDate(
                DateTime.now().subtract(const Duration(days: 365)))));

      case RecordQuery.month:
        return where("time",
            isGreaterThan: (Timestamp.fromDate(
                DateTime.now().subtract(const Duration(days: 31)))));

      case RecordQuery.week:
        return where("time",
            isGreaterThan: (Timestamp.fromDate(DateTime.now()
                .subtract(Duration(days: DateTime.now().weekday)))));
    }
  }
}

enum BudgetType {
  year,
  month,
  week,
}

extension on Query<FakeBudget> {
  Query<FakeBudget> queryBy(BudgetType query) {
    switch (query) {
      case BudgetType.year:
        return where("uuid", isEqualTo: "123456")
            .where("range", isEqualTo: "yearly");

      case BudgetType.month:
        return where("uuid", isEqualTo: "123456")
            .where("range", isEqualTo: "monthly");

      case BudgetType.week:
        return where("uuid", isEqualTo: "123456")
            .where("range", isEqualTo: "weekly");
    }
  }
}

class Track extends StatelessWidget {
  const Track({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Analytics();
  }
}

class Analytics extends StatefulWidget {
  const Analytics({Key? key}) : super(key: key);

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  RecordQuery queryType = RecordQuery.showDescendingData;
  BudgetType budgetType = BudgetType.year;

  dynamic refresh(RecordQuery newType, BudgetType newBudget) {
    // update the query
    setState(() {
      // modify type via Extension
      queryType = newType;
      budgetType = newBudget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<FakeSpendRecord>>(
        stream: fakeSpendRecordEntries.queryBy(queryType).snapshots(),
        builder: (context, snapshot) {
          // error checking
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Loading..."));
          }

          final data = snapshot.requireData;

          // final List<FakeSpendRecord> history =
          //     data.docs.map((e) => e.data()).toList();

          return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Flexible(
                  flex: 1,
                  child: halfSpacing,
                ),
                const Flexible(
                  flex: 1,
                  child: YouHaveSpent(),
                ),
                Flexible(
                  flex: 5,
                  child: SpendGraph(
                      data.docs.map((e) => e.data()).toList(), budgetType),
                ),
                Flexible(
                    flex: 2,
                    //padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: showBudgetButton(context)),
                Flexible(
                    flex: 4,
                    // padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GenerateChart(
                            data.docs.map((e) => e.data()).toList(), queryType)
                        .buildChart()),
                Flexible(flex: 1, child: filters),
              ]);
        });
  }

  Widget showBudgetButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const BudgetView();
            });
      },
      child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          width: 200,
          decoration: BoxDecoration(
            // border: Border.all(color: Colors.black),
            color: navyBlue,
            borderRadius: regularRadius,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              "Set budget",
              style: ordinaryStyle.copyWith(color: Colors.white),
              textAlign: TextAlign.start,
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ])),
    );
  }

  Container generateAddButton(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AddingShopForm();
              });
        },
        backgroundColor: mintGreen,
        child: const Icon(Icons.add),
      ),
    );
  }

  SizedBox generateHistory(List<FakeSpendRecord> history) {
    return SizedBox(
        width: 270,
        height: 100,
        child: Table(
          border: TableBorder.all(),
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(150),
            1: FlexColumnWidth(120),
            2: FixedColumnWidth(50),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: generateRows(history)
          // generateOneRecord(history[0]),
          // generateOneRecord(history[1]),
          // generateOneRecord(history[2]),
          ,
        ));
  }

  List<TableRow> generateRows(List<FakeSpendRecord> history) {
    List<TableRow> rows = [];
    for (var i = 0; i < history.length; i++) {
      rows.add(generateOneRecord(history[i]));
    }
    return rows;
  }

  Widget get filters => ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [
          ButtonGenerator(
            text: "All",
            notifyParent: refresh,
            queryType: RecordQuery.all,
            budgetType: BudgetType.year,
          ),
          ButtonGenerator(
            text: "This Year",
            notifyParent: refresh,
            queryType: RecordQuery.year,
            budgetType: BudgetType.year,
          ),
          ButtonGenerator(
            text: "This Month",
            notifyParent: refresh,
            queryType: RecordQuery.month,
            budgetType: BudgetType.month,
          ),
          ButtonGenerator(
            text: "This Week",
            notifyParent: refresh,
            queryType: RecordQuery.week,
            budgetType: BudgetType.week,
          ),
        ],
      );

  generateOneRecord(FakeSpendRecord record) {
    return TableRow(
      children: <Widget>[
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: SizedBox(
              height: 32,
              width: 120,
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    record.store,
                    style: smallStyle,
                  ))),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: SizedBox(
              height: 32,
              width: 40,
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    DateFormat('yyyy-MM-dd').format(record.time),
                    style: smallStyle,
                  ))),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: SizedBox(
              height: 32,
              width: 60,
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "£${record.amount.toStringAsFixed(0)}",
                    style: smallStyle,
                  ))),
        )
      ],
    );
  }
}

class YouHaveSpent extends StatelessWidget {
  const YouHaveSpent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
      child: const Text(
        "You have spent:",
        style: largeTitleStyle,
      ),
    );
  }
}

class SpendAmt extends StatelessWidget {
  final List<FakeSpendRecord> records;
  final NumberFormat formatCurrency =
      NumberFormat.currency(locale: "en_GB", symbol: "£");

  SpendAmt(this.records, {Key? key}) : super(key: key);

  Widget get expenseSummary {
    return Text(
      formatCurrency.format(records.map((record) => record.amount).sum),
      style: hugeStyle,
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 200,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Align(alignment: Alignment.center, child: expenseSummary),
    );
  }
}

class SpendGraph extends StatelessWidget {
  final List<FakeSpendRecord> records;
  final NumberFormat formatCurrency =
      NumberFormat.currency(locale: "en_GB", symbol: "£");
  final BudgetType budgetType;

  SpendGraph(this.records, this.budgetType, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double amt = records.map((record) => record.amount).sum.toDouble();
    final String strAmt = formatCurrency.format(amt);

    return StreamBuilder(
        stream: fakeBudgetEntries.queryBy(budgetType).snapshots(),
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Loading..."));
          }

          final data = snapshot.requireData as QuerySnapshot<FakeBudget>;
          final double budget = data.docs.first.data().amount.toDouble();

          return SfRadialGauge(
            enableLoadingAnimation: true,
            axes: <RadialAxis>[
              RadialAxis(
                  showLabels: false,
                  showTicks: false,
                  radiusFactor: 0.8,
                  maximum: budget,
                  axisLineStyle: const AxisLineStyle(
                      cornerStyle: CornerStyle.startCurve, thickness: 5),
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        angle: 90,
                        widget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(strAmt,
                                style: largeTitleStyle.copyWith(
                                    fontSize: 40, fontWeight: FontWeight.w700)),
                          ],
                        )),
                    const GaugeAnnotation(
                      angle: 124,
                      positionFactor: 1.17,
                      widget: Text('£0', style: TextStyle(fontSize: 20)),
                    ),
                    GaugeAnnotation(
                      angle: 54,
                      positionFactor: 1.17,
                      widget: Text('£${budget.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 20)),
                    ),
                  ],
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: amt,
                      width: 18,
                      pointerOffset: -6,
                      cornerStyle: CornerStyle.bothCurve,
                      color: const Color(0xFFF67280),
                      gradient: const SweepGradient(
                          colors: <Color>[Color(0xFFFF7676), Color(0xFFF54EA2)],
                          stops: <double>[0.25, 0.75]),
                    ),
                    // MarkerPointer(
                    //   value: amt - 6 / amt / (snapshot.data as double),
                    //   color: Colors.white,
                    //   markerType: MarkerType.circle,
                    // ),
                  ]),
            ],
          );
        });
  }
}
