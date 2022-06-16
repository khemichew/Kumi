import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/style.dart';
import 'package:pie_chart/pie_chart.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class SavingsPage extends StatelessWidget {
  SavingsPage({Key? key}) : super(key: key);

  Map<String, double> buildDataMap(double groceryAmt, double foodAmt, double fashionAmt, double hcAmt) {
    double total = groceryAmt + foodAmt + fashionAmt + hcAmt;
    double groceryPercent = groceryAmt / total * 100;
    String groceryEntry = "Grocery:  ${groceryPercent.toStringAsFixed(0)}%";
    double foodPercent = foodAmt / total * 100;
    String foodEntry = "Food:  ${foodPercent.toStringAsFixed(0)}%";
    double fashionPercent = fashionAmt / total * 100;
    String fashionEntry = "Fashion:  ${fashionPercent.toStringAsFixed(0)}%";
    double hcPercent = hcAmt / total * 100;
    String hcEntry = "Healthcare:  ${hcPercent.toStringAsFixed(0)}%";
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
      margin: const EdgeInsets.fromLTRB(15, 40, 15, 0),
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
          const SavingTable(),

          Container(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AddingShopForm();
                    }
                );
              },
              backgroundColor: const Color.fromRGBO(53, 219, 169, 1.0),
              child: const Icon(Icons.add),
            ),
          ),
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
        alignment: Alignment.center,
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
          child: Text("\$6324", style: hugeStyle,),
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
    return SizedBox(
      width: MediaQuery. of(context). size. width * 5,
        child: Row(
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
          child: const Text('This Week',style: filterStyle, ),
        ),
      ],
    ));
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

class AddingShopForm extends StatefulWidget {
  const AddingShopForm({super.key});

  @override
  AddShoppingState createState() => AddShoppingState();
}

class AddShoppingState extends State<AddingShopForm> {

  final storeController = TextEditingController();
  final amountController = TextEditingController();
  final dateController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    storeController.dispose();
    amountController.dispose();
    dateController.dispose();
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
      child: contentBox(context),
    );
  }

  Future<void> addShopping(String store, String amount, String date) {
    return FirebaseFirestore.instance.collection("test-spend-record")
        .add({
      'store': store,
      'amount': amount,
      'date': date
        });
  }

  contentBox(context) {
    return Container(
      height: 250,
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: defaultBoxShadow
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text("         Store: ", style: ordinaryStyle,),
                SizedBox(
                  width: 120,
                  height: 40,
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    controller: storeController,
                  ),
                ),
                Text((storeController.text))
              ],

            ),
            const SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text("Amount:  £ ", style: ordinaryStyle),
                SizedBox(
                  width: 120,
                  height: 40,
                  child: TextField(
                    style: smallStyle,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    controller: amountController,
                  ),
                ),
                Text((amountController.text))
              ],

            ),
            const SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text("          Date:  ", style: ordinaryStyle,),
                SizedBox(
                  width: 120,
                  height: 40,
                  child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      hintText: 'dd-mm-yyyy'
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    controller: dateController,
                  ),
                ),
                Text((dateController.text))
              ],

            ),
            const SizedBox(height: 10,),

            TextButton(
              onPressed: () {
                addShopping(storeController.text, amountController.text, dateController.text);
                Navigator.pop(context);
              },
              child: Container(
                height: 40,
                width: 500,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black
                  ),
                  color: const Color.fromRGBO(53, 219, 169, 1.0),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: const Text("Submit", style: ordinaryStyle, textAlign: TextAlign.center,)
              )
            )
          ],
        )
    );
  }
}
