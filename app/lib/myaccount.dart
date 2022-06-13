import 'package:flutter/material.dart';
import 'package:app/style.dart';

class MyaccountPage extends StatelessWidget {
  const MyaccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 50, 20, 0),
      child: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'My\nAccount',
                    style: titleStyle,
                  ),
                ]
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: const [
                  PersonalDetail(field: "Name", entry: "Jim Brown"),
                  PersonalDetail(field: "Email Address", entry: "123@dmail.com")
              ],
            )
          ]
      ),
    );
  }
}

class PersonalDetail extends StatelessWidget {
  const PersonalDetail({Key? key, required this.field, required this.entry}) : super(key: key);

  final String field;
  final String entry;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(field, style: titleStyle),
            Text(entry, style: ordinaryStyle),
          ],
        ),
      ),
    );
  }
}