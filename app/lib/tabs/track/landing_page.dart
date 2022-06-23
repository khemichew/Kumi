import 'package:app/models/fake_budget.dart';
import 'package:app/models/fake_spend_record.dart';
import 'package:app/config/style.dart';
import 'package:app/tabs/track/budget.dart';
import 'package:app/tabs/track/add_button.dart';
import 'package:app/tabs/track/button_generator.dart';
import 'package:app/tabs/track/generate_chart.dart';
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

  // Stream<QuerySnapshot<FakeSpendRecord>> queryStream = fakeSpendRecordEntries.snapshots();

  dynamic refresh(RecordQuery newType) {
    // update the query
    setState(() {
      // modify type via Extension
      queryType = newType;
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
                const SizedBox(
                  height: 60,
                ),
                const Flexible(
                  flex: 1,
                  child: YouHaveSpent(),
                ),
                Flexible(
                  flex: 5,
                  child: SpendGraph(
                      data.docs.map((e) => e.data()).toList(), queryType),
                ),
                Flexible(
                    flex: 1,
                    //padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: showBudgetButton(context)),
                Flexible(
                    flex: 4,
                    // padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GenerateChart(
                            data.docs.map((e) => e.data()).toList(), queryType)
                        .buildChart()),
                Flexible(flex: 1, child: generateFilters()),
                const SizedBox(
                  height: 10,
                ),
              ]);
        });
  }

  Container showBudgetButton(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: TextButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const BudgetView();
                });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0.0),
              child: const Text(
                "Budget Settings",
                style: ordinaryStyle,
                textAlign: TextAlign.center,
              )),
        ));
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

  Row generateFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ButtonGenerator(
          text: "All",
          notifyParent: refresh,
          queryType: RecordQuery.all,
        ),
        ButtonGenerator(
          text: "This Year",
          notifyParent: refresh,
          queryType: RecordQuery.year,
        ),
        ButtonGenerator(
          text: "This Month",
          notifyParent: refresh,
          queryType: RecordQuery.month,
        ),
        ButtonGenerator(
          text: "This Week",
          notifyParent: refresh,
          queryType: RecordQuery.week,
        ),
      ],
    );
  }

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
  final RecordQuery queryType;

  SpendGraph(this.records, this.queryType, {Key? key}) : super(key: key);

  Future<double> getYearly() async {
    var snapshot = await fakeBudgetEntries
        .where('uuid', isEqualTo: "123456")
        .where("range", isEqualTo: "yearly")
        .get();
    return snapshot.docs.first.data().amount.toDouble();
  }

  Future<double> getMonthly() async {
    var snapshot = await fakeBudgetEntries
        .where('uuid', isEqualTo: "123456")
        .where("range", isEqualTo: "monthly")
        .get();
    return snapshot.docs.first.data().amount.toDouble();
  }

  Future<double> getWeekly() async {
    var snapshot = await fakeBudgetEntries
        .where('uuid', isEqualTo: "123456")
        .where("range", isEqualTo: "weekly")
        .get();
    return snapshot.docs.first.data().amount.toDouble();
  }

  Future<double> getBudget() {
    if (queryType == RecordQuery.month) {
      return getMonthly();
    }
    if (queryType == RecordQuery.week) {
      return getWeekly();
    }
    return getYearly();
  }

  @override
  Widget build(BuildContext context) {
    final double amt = records.map((record) => record.amount).sum.toDouble();
    final String strAmt = formatCurrency.format(amt);
    double budget = 100;

    return FutureBuilder(
        future: getBudget(),
        builder: (context, snapshot) {

        if (snapshot.data != null) {
          budget = snapshot.data as double;

          return SizedBox(
              width: 370,
              height: 280,
              child: SfRadialGauge(
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
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 50)),
                              ],
                            )),
                        const GaugeAnnotation(
                          angle: 124,
                          positionFactor: 1.1,
                          widget: Text('0', style: TextStyle(fontSize: 20)),
                        ),
                        GaugeAnnotation(
                          angle: 54,
                          positionFactor: 1.1,
                          widget: Text('$budget',
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
                          gradient: const SweepGradient(colors: <Color>[
                            Color(0xFFFF7676),
                            Color(0xFFF54EA2)
                          ], stops: <double>[
                            0.25,
                            0.75
                          ]),
                        ),
                        // MarkerPointer(
                        //   value: amt - 6 / amt / (snapshot.data as double),
                        //   color: Colors.white,
                        //   markerType: MarkerType.circle,
                        // ),
                      ]),
                ],
              )
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        }
    );
  }
}
