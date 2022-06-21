import 'dart:io';
import 'package:app/models/fake_spend_record.dart';
import 'package:app/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum RecordQuery {
  showDescendingData,
  all,
  year,
  month,
  week,
}

@immutable
class TotalRecord {
  final num amount;
  final int timeInterval;

  const TotalRecord({
    required this.amount,
    required this.timeInterval,
  });
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
            isGreaterThan: (Timestamp.fromDate(
                DateTime.now().subtract(const Duration(days: 7)))));
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
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
              child: const Text(
                "You have spent:",
                style: largeTitleStyle,
              ),
            ),
            const SizedBox(
              width: 100,
              height: 10,
            ),
            SpendAmt(data.docs.map((e) => e.data()).toList()),
            const SizedBox(
              width: 100,
              height: 10,
            ),
            Row(
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
            ),
            const SizedBox(
              width: 100,
              height: 10,
            ),
            Container(
                height: 180,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BarChart(queryType == RecordQuery.year
                    ? monthlyData(data.docs.map((e) => e.data()).toList())
                    : queryType == RecordQuery.month
                        ? weeklyData(data.docs.map((e) => e.data()).toList())
                        : queryType == RecordQuery.week
                            ? dailyData(data.docs.map((e) => e.data()).toList())
                            : yearlyData(
                                data.docs.map((e) => e.data()).toList()))),
            const SizedBox(
              width: 100,
              height: 10,
            ),
            Container(
              width: 100,
              height: 30,
              alignment: Alignment.centerLeft,
              child: const Align(
                child: Text(
                  "History",
                  style: ordinaryStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
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
                  children: <TableRow>[
                    generateOneRecord(history[0]),
                    generateOneRecord(history[1]),
                    generateOneRecord(history[2]),
                    generateOneRecord(history[3]),
                    generateOneRecord(history[4]),
                  ],
                )),
            Container(
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
            ),
          ]);
        });
  }

  BarChartData dailyData(List<FakeSpendRecord> data) {
    final Map<int, List<FakeSpendRecord>> info = groupBy(
        data.where((dataItem) =>
            dataItem.time.month == DateTime.now().month &&
            dataItem.time.day ~/ 7 == DateTime.now().day ~/ 7 &&
            dataItem.time.year == DateTime.now().year), (FakeSpendRecord r) {
      return r.time.weekday;
    });
    List<TotalRecord> list = groupTimeInterval(info);
    return BarChartData(
      borderData: FlBorderData(
          border: const Border(
        top: BorderSide.none,
        right: BorderSide.none,
        left: BorderSide(width: 1),
        bottom: BorderSide(width: 1),
      )),
      groupsSpace: 10,
      barGroups: list
          .map((dataItem) =>
              BarChartGroupData(x: dataItem.timeInterval, barRods: [
                BarChartRodData(
                    y: dataItem.amount.toDouble(),
                    width: 15,
                    colors: [Colors.deepPurpleAccent]),
              ]))
          .toList(),
      titlesData: FlTitlesData(
          show: true,
          rightTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
          bottomTitles: SideTitles(
            showTitles: true,
            getTitles: dailyBottomTitles,
            reservedSize: 42,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            interval: 1,
            getTitles: dailyLeftTitles,
          )),
    );
  }

  String dailyLeftTitles(double value) {
    String ret = "";
    if (value.toInt() % 10 == 0) {
      ret = '£${value.toStringAsFixed(0)}';
    }
    return ret;
  }

  String dailyBottomTitles(double value) {
    String text;
    switch (value.toInt()) {
      case 1:
        text = "Mon";
        break;
      case 2:
        text = "Tue";
        break;
      case 3:
        text = 'Wed';
        break;
      case 4:
        text = 'Thu';
        break;
      case 5:
        text = 'Fri';
        break;
      case 6:
        text = 'Sat';
        break;
      case 7:
        text = 'Sun';
        break;
      default:
        text = '';
        break;
    }
    return text;
  }

  BarChartData weeklyData(List<FakeSpendRecord> data) {
    final Map<int, List<FakeSpendRecord>> info = groupBy(
        data.where((dataItem) =>
            dataItem.time.month == DateTime.now().month &&
            dataItem.time.year == DateTime.now().year), (FakeSpendRecord r) {
      return r.time.day ~/ 7;
    });
    List<TotalRecord> list = groupTimeInterval(info);
    return BarChartData(
      borderData: FlBorderData(
          border: const Border(
        top: BorderSide.none,
        right: BorderSide.none,
        left: BorderSide(width: 1),
        bottom: BorderSide(width: 1),
      )),
      groupsSpace: 10,
      barGroups: list
          .map((dataItem) =>
              BarChartGroupData(x: dataItem.timeInterval, barRods: [
                BarChartRodData(
                    y: dataItem.amount.toDouble(),
                    width: 15,
                    colors: [Colors.amber]),
              ]))
          .toList(),
      titlesData: FlTitlesData(
          show: true,
          rightTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
          bottomTitles: SideTitles(
            showTitles: true,
            getTitles: weeklyBottomTitles,
            reservedSize: 42,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            interval: 1,
            getTitles: weeklyLeftTitles,
          )),
    );
  }

  String weeklyLeftTitles(double value) {
    String ret = "";
    if (value.toInt() % 10 == 0) {
      ret = '£${value.toStringAsFixed(0)}';
    }
    return ret;
  }

  String weeklyBottomTitles(double value) {
    value = value + 1;
    return 'Week ${value.toStringAsFixed(0)}';
  }

  BarChartData monthlyData(List<FakeSpendRecord> data) {
    final Map<int, List<FakeSpendRecord>> info = groupBy(
        data.where((dataItem) => dataItem.time.year == DateTime.now().year),
        (FakeSpendRecord r) {
      return r.time.month;
    });
    List<TotalRecord> list = groupTimeInterval(info);
    return BarChartData(
      borderData: FlBorderData(
          border: const Border(
        top: BorderSide.none,
        right: BorderSide.none,
        left: BorderSide(width: 1),
        bottom: BorderSide(width: 1),
      )),
      groupsSpace: 10,
      barGroups: list
          .map((dataItem) =>
              BarChartGroupData(x: dataItem.timeInterval, barRods: [
                BarChartRodData(
                    y: dataItem.amount.toDouble(),
                    width: 15,
                    colors: [Colors.blue]),
              ]))
          .toList(),
      titlesData: FlTitlesData(
          show: true,
          rightTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
          bottomTitles: SideTitles(
            showTitles: true,
            getTitles: monthlyBottomTitles,
            reservedSize: 20,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            interval: 1,
            getTitles: monthlyLeftTitles,
          )),
    );
  }

  String monthlyBottomTitles(double value) {
    String text;
    switch (value.toInt()) {
      case 1:
        text = "Jan";
        break;
      case 2:
        text = "Feb";
        break;
      case 3:
        text = 'Mar';
        break;
      case 4:
        text = 'Apr';
        break;
      case 5:
        text = 'May';
        break;
      case 6:
        text = 'Jun';
        break;
      case 7:
        text = 'Jul';
        break;
      case 8:
        text = 'Aug';
        break;
      case 9:
        text = 'Sep';
        break;
      case 10:
        text = 'Oct';
        break;
      case 11:
        text = 'Nov';
        break;
      case 12:
        text = 'Dec';
        break;
      default:
        text = '';
        break;
    }
    return text;
  }

  String monthlyLeftTitles(double value) {
    String ret = "";
    if (value.toInt() % 20 == 0) {
      ret = '£${value.toStringAsFixed(0)}';
    }
    return ret;
  }

  BarChartData yearlyData(List<FakeSpendRecord> data) {
    final Map<int, List<FakeSpendRecord>> info =
        groupBy(data, (FakeSpendRecord r) {
      return r.time.year;
    });
    List<TotalRecord> list = groupTimeInterval(info);
    return BarChartData(
      borderData: FlBorderData(
          border: const Border(
        top: BorderSide.none,
        right: BorderSide.none,
        left: BorderSide(width: 1),
        bottom: BorderSide(width: 1),
      )),
      groupsSpace: 10,
      barGroups: list
          .map((dataItem) =>
              BarChartGroupData(x: dataItem.timeInterval, barRods: [
                BarChartRodData(
                    y: dataItem.amount.toDouble(),
                    width: 15,
                    colors: [Colors.red]),
              ]))
          .toList(),
      titlesData: FlTitlesData(
          show: true,
          rightTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
          bottomTitles: SideTitles(
            showTitles: true,
            getTitles: (e) => "2022",
            reservedSize: 42,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            interval: 1,
            getTitles: yearlyLeftTitles,
          )),
    );
  }

  String yearlyLeftTitles(double value) {
    String ret = "";
    if (value.toInt() % 100 == 0) {
      ret = '£${value.toStringAsFixed(0)}';
    }
    return ret;
  }

  List<TotalRecord> groupTimeInterval(Map<int, List<FakeSpendRecord>> info) {
    List<TotalRecord> list = [];
    info.forEach((k, v) => list.add(TotalRecord(
        amount: v.map((e) => e.amount).sum.toDouble(), timeInterval: k)));
    return list;
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

class AddingShopForm extends StatefulWidget {
  const AddingShopForm({super.key});

  @override
  AddShoppingState createState() => AddShoppingState();
}

class AddShoppingState extends State<AddingShopForm> {
  DateTime selectedDate = DateTime.now();

  final storeController = TextEditingController();
  final amountController = TextEditingController();
  final dateController = TextEditingController();

  String dropdownvalue = 'Tesco';

  var items = [
    'Tesco',
    'Sainsburys',
    'Waitrose',
    'Boots',
    'Holland & Barrette',
    'Mark & Spencer'
  ];

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
    return FirebaseFirestore.instance.collection("test-spend-record").add({
      'store': store,
      'amount': amount,
      'time': Timestamp.fromDate(DateTime.parse(date))
    });
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController timeController) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        locale: const Locale("en", "EN"),
        initialDate: selectedDate,
        firstDate: DateTime(2010),
        lastDate: DateTime(2100));

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        timeController.text = selectedDate.toString();
      });
    }
  }

  contentBox(context) {
    return Container(
        height: 500,
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: defaultBoxShadow),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Store:",
                  style: ordinaryStyle,
                ),
                SizedBox(
                  width: 160,
                  height: 40,
                  child: DropdownButton(
                    // Initial Value
                    value: dropdownvalue,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                        storeController.text = newValue;
                      });
                    },
                  ),
                ),
                //Text((storeController.text))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "Date:",
                  style: ordinaryStyle,
                ),
                Container(
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: TextButton(
                    onPressed: () {
                      _selectDate(context, dateController);
                    },
                    child: Text("${selectedDate.toLocal()}".split(' ')[0]),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const ImageUploads(),
            const SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: () {
                  addShopping(storeController.text, amountController.text,
                      dateController.text);
                  Navigator.pop(context);
                },
                child: Container(
                    height: 40,
                    width: 500,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: const Color.fromRGBO(53, 219, 169, 1.0),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    child: const Text(
                      "Submit",
                      style: ordinaryStyle,
                      textAlign: TextAlign.center,
                    )))
          ],
        ));
  }
}

class ImageUploads extends StatefulWidget {
  const ImageUploads({Key? key}) : super(key: key);

  @override
  _ImageUploadsState createState() => _ImageUploadsState();
}

class _ImageUploadsState extends State<ImageUploads> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future getFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future getFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_photo!);
    } catch (e) {
      print('error occurred');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          imagePicker(context);
        },
        child: Container(
            height: 40,
            width: 500,
            color: Colors.grey,
            child: const Text(
              "Upload receipt",
              style: ordinaryStyle,
              textAlign: TextAlign.center,
            )));
    //   Scaffold(
    //   appBar: AppBar(),
    //   body: Column(
    //     children: <Widget>[
    //       SizedBox(
    //         height: 32,
    //       ),
    //       Center(
    //         child: GestureDetector(
    //           onTap: () {
    //             imagePicker(context);
    //           },
    //           child: CircleAvatar(
    //             radius: 55,
    //             backgroundColor: Color(0xffFDCF09),
    //             child: _photo != null
    //                 ? ClipRRect(
    //               borderRadius: BorderRadius.circular(50),
    //               child: Image.file(
    //                 _photo!,
    //                 width: 100,
    //                 height: 100,
    //                 fit: BoxFit.fitHeight,
    //               ),
    //             )
    //                 : Container(
    //               decoration: BoxDecoration(
    //                   color: Colors.grey[200],
    //                   borderRadius: BorderRadius.circular(50)),
    //               width: 100,
    //               height: 100,
    //               child: Icon(
    //                 Icons.camera_alt,
    //                 color: Colors.grey[800],
    //               ),
    //             ),
    //           ),
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }

  void imagePicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Gallery'),
                    onTap: () {
                      getFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    getFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}
