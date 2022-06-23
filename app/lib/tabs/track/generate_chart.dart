import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../models/fake_spend_record.dart';
import 'landing_page.dart';

enum TimeInterval { week, month, year }

@immutable
class TotalRecord {
  final num amount;
  final int timeInterval;

  const TotalRecord({
    required this.amount,
    required this.timeInterval,
  });
}

class GenerateChart {
  final List<FakeSpendRecord> records;
  final RecordQuery queryType;
  TimeInterval interval = TimeInterval.month;

  GenerateChart(this.records, this.queryType);

  Widget buildChart() {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: BarChart(queryType == RecordQuery.year
            ? monthlyData(records)
            : queryType == RecordQuery.month
            ? weeklyData(records)
            : queryType == RecordQuery.week
            ? dailyData(records)
            : yearlyData(records)
        ),
      );
  }

  BarChartData dailyData(List<FakeSpendRecord> data) {
    final Map<int, List<FakeSpendRecord>> info = groupBy(
        data.where((dataItem) =>
        dataItem.time.month == DateTime.now().month &&
            dataItem.time.year == DateTime.now().year), (FakeSpendRecord r) {
      return r.time.weekday;
    });
    List<TotalRecord> list = [];
    info.forEach((k, v) =>
        list.add(TotalRecord(amount: groupTimeInterval(v), timeInterval: k)));
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

  BarChartData weeklyData(List<FakeSpendRecord> data) {
    final Map<int, List<FakeSpendRecord>> info = groupBy(
        data.where((dataItem) =>
        dataItem.time.month == DateTime.now().month &&
            dataItem.time.year == DateTime.now().year), (FakeSpendRecord r) {
      return r.time.day ~/ 7;
    });
    List<TotalRecord> list = [];
    info.forEach((k, v) =>
        list.add(TotalRecord(amount: groupTimeInterval(v), timeInterval: k)));
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

  BarChartData monthlyData(List<FakeSpendRecord> data) {
    final Map<int, List<FakeSpendRecord>> info = groupBy(
        data.where((dataItem) => dataItem.time.year == DateTime.now().year),
            (FakeSpendRecord r) {
          return r.time.month;
        });
    List<TotalRecord> list = [];
    info.forEach((k, v) =>
        list.add(TotalRecord(amount: groupTimeInterval(v), timeInterval: k)));
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

  BarChartData yearlyData(List<FakeSpendRecord> data) {
    final Map<int, List<FakeSpendRecord>> info =
    groupBy(data, (FakeSpendRecord r) {
      return r.time.year;
    });
    List<TotalRecord> list = [];
    info.forEach((k, v) =>
        list.add(TotalRecord(amount: groupTimeInterval(v), timeInterval: k)));
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

  String yearlyLeftTitles(double value) {
    String ret = "";
    if (value.toInt() % 100 == 0) {
      ret = '£${value.toStringAsFixed(0)}';
    }
    return ret;
  }

  double groupTimeInterval(List<FakeSpendRecord> v) {
    double total = v.map((e) => e.amount).sum.toDouble();
    return total;
  }
}