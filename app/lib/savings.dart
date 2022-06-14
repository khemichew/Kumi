import 'package:flutter/material.dart';
import 'package:app/style.dart';
import 'package:pie_chart/pie_chart.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class SavingsPage extends StatelessWidget {
  SavingsPage({Key? key}) : super(key: key);

  Map<String, double> buildDataMap(double groceryAmt, double foodAmt, double fashionAmt, double hcAmt) {
    double total = groceryAmt + foodAmt + fashionAmt + hcAmt;
    double groceryPercent = groceryAmt / total;
    String groceryEntry = "Grocery:  ${groceryPercent.toStringAsFixed(2)}%";
    double foodPercent = foodAmt / total;
    String foodEntry = "Food:  ${foodPercent.toStringAsFixed(2)}%";
    double fashionPercent = fashionAmt / total;
    String fashionEntry = "Fashion:  ${fashionPercent.toStringAsFixed(2)}%";
    double hcPercent = hcAmt / total;
    String hcEntry = "Healthcare:  ${hcPercent.toStringAsFixed(2)}%";
    return <String, double>{groceryEntry: groceryAmt, foodEntry: foodAmt, fashionEntry: fashionAmt, hcEntry: hcAmt };
  }

  // final Map<String, double> dataMap = buildDataMap(36.75, 46.20, 19.99, 5.50);

  final colorList = <Color>[
    Colors.orangeAccent,
    Colors.blueAccent,
    Colors.indigo,
    Colors.deepOrangeAccent
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 80, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: const Text(
              "You have saved:",
              style: largeTitleStyle,
            ),
          ),

          const SavingAmount(),
          const PieChartFilter(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PieChart(
              totalValue: 100,
              dataMap: buildDataMap(36.75, 46.20, 19.99, 5.50),
              chartType: ChartType.ring,
              colorList: colorList,
            )
          ),
          const SavingAmtFilter(),
          const SavingTable()
        ],
      ),
    );
  }
}

class SavingTable extends StatelessWidget {
  const SavingTable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(border: TableBorder.all(),
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
        2: FixedColumnWidth(64),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: const <TableRow>[
        TableRow(
          children: <Widget>[
            SavingStore(store: "Store A"),
            SavingAmt(amount: "\$5.60")
          ],
        ),
        TableRow(
          children: <Widget>[
        SavingStore(store: "Store B"),
            SavingAmt(amount: "\$5.60")
          ],
        ),
        TableRow(
          children: <Widget>[
            SavingStore(store: "Store C"),
            SavingAmt(amount: "\$5.60")
          ],
        ),
      ],);
  }
}

class SavingAmount extends StatelessWidget {
  const SavingAmount({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
        decoration:BoxDecoration(
            border: Border.all(
                color: Colors.black,
                width: 2
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))
        ),
        child: const Align(
          alignment: Alignment.center,
          child:
            Text("\$6324", style: hugeStyle,)
        ),
    );
  }
}

class PieChartFilter extends StatelessWidget {
  const PieChartFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          style: outlineButtonStyle,
          onPressed: () { },
          child: const Text('All', style: filterStyle,),
        ),
        TextButton(
          style: outlineButtonStyle,
          onPressed: () { },
          child: const Text('This Year',style: filterStyle,),
        ),
        TextButton(
          style: outlineButtonStyle,
          onPressed: () { },
          child: const Text('This Month',style: filterStyle,),
        ),
        TextButton(
          style: outlineButtonStyle,
          onPressed: () { },
          child: const Text('This Week',style: filterStyle,),
        ),
      ],
    );
  }
}

class SavingStore extends StatelessWidget {
  const SavingStore({Key? key, required this.store}) : super(key: key);

  final String store;

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: SizedBox(
          height: 32,
          width: 60,
          child: Align(
              alignment: Alignment.center,
              child: Text(store, style: smallStyle,)
          )
      ),
    );
  }
}

class SavingAmt extends StatelessWidget {
  const SavingAmt({Key? key, required this.amount}) : super(key: key);

  final String amount;

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: SizedBox(
          height: 32,
          width: 80,
          child: Align(
              alignment: Alignment.center,
              child: Text(amount, style: smallStyle,)
          )
      ),
    );
  }
}


class SavingAmtFilter extends StatelessWidget {
  const SavingAmtFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 25,
          width: 40,
          margin: EdgeInsets.zero,
          child: TextButton(
            style: smallOptStyle,
            onPressed: () { },
            child: const Text('All', style: smallOptTextStyle,),
          )
        ),
        Container(
            height: 25,
            width: 50,
            margin: EdgeInsets.zero,
            child: TextButton(
              style: smallOptStyle,
              onPressed: () { },
              child: const Text('Recent', style: smallOptTextStyle,),
            )
        ),
        Container(
            height: 25,
            width: 55,
            margin: EdgeInsets.zero,
            child: TextButton(
              style: smallOptStyle,
              onPressed: () { },
              child: const Text('Grocery', style: smallOptTextStyle,),
            )
        ),
        Container(
            height: 25,
            width: 40,
            margin: EdgeInsets.zero,
            child: TextButton(
              style: smallOptStyle,
              onPressed: () { },
              child: const Text('Food', style: smallOptTextStyle,),
            )
        ),
        Container(
            height: 25,
            width: 70,
            margin: EdgeInsets.zero,
            child: TextButton(
              style: smallOptStyle,
              onPressed: () { },
              child: const Text('Healthcare', style: smallOptTextStyle,),
            )
        ),
      ],
    );
  }
}

