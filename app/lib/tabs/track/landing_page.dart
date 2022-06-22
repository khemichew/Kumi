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
            return const Center(child: Text("No entries found"));
          }

          final data = snapshot.requireData;

          final List<FakeSpendRecord> history =
              data.docs.map((e) => e.data()).toList();

          return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SizedBox(
              width: 100,
              height: 50,
            ),
            const YouHaveSpent(),
            const SizedBox(
              width: 100,
              height: 10,
            ),
            SpendAmt(data.docs.map((e) => e.data()).toList()),
            const SizedBox(
              width: 100,
              height: 10,
            ),
            generateFilters(),
            const SizedBox(
              width: 100,
              height: 10,
            ),
            Container(
                height: 180,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GenerateChart(
                        data.docs.map((e) => e.data()).toList(), queryType)
                    .buildChart()

                // BarChart(queryType == RecordQuery.year
                //     ? monthlyData(data.docs.map((e) => e.data()).toList())
                //     : queryType == RecordQuery.month
                //         ? weeklyData(data.docs.map((e) => e.data()).toList())
                //         : queryType == RecordQuery.week
                //             ? dailyData(data.docs.map((e) => e.data()).toList())
                //             : yearlyData(
                //                 data.docs.map((e) => e.data()).toList())
                // )
                ),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: showBudgetButton(context)),


            // Container(
            //   width: 100,
            //   height: 30,
            //   alignment: Alignment.centerLeft,
            //   child: const Align(
            //     child: Text(
            //       "History",
            //       style: ordinaryStyle,
            //       textAlign: TextAlign.center,
            //     ),
            //   ),
            // ),
            // generateHistory(history),
            // generateAddButton(context),
          ]);
        });
  }

  Container showBudgetButton(BuildContext context) {
    return Container(
        alignment: Alignment.topLeft,
        child: TextButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const BudgetView();
                });
          },
          child: Container(
              height: 40,
              width: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0.0),
              child: const Text(
                "View My Budget",
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
        backgroundColor: const Color.fromRGBO(53, 219, 169, 1.0),
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
      mainAxisAlignment: MainAxisAlignment.center,
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
