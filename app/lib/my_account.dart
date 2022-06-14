import 'package:flutter/material.dart';
import 'package:app/style.dart';

class MyAccountPage extends StatelessWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 60, 20, 0),
      child: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'My\naccount',
                    style: largeTitleStyle,
                  ),
                  // Image(image: AssetImage('../asset/dingzhen_cute.jpeg'))
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/dzdl.jpeg'),
                    radius: 60,
                  )
                ]
            ),
              // mainAxisSize: MainAxisSize.max,
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.topLeft,
              child: PersonalDetail(field: "Name", entry: "Jim Brown")
            ),
            const SizedBox(height: 30),
            const Align(
                alignment: Alignment.topLeft,
                child: PersonalDetail(field: "Email address", entry: "jim.brown@dmail.com")
            ),
            const SizedBox(height: 30),
            const Align(
                alignment: Alignment.topLeft,
                child: PersonalDetail(field: "Phone number", entry: "1234567890")
            ),
            const SizedBox(height: 50),
            Container(
              height: 80,
              decoration:BoxDecoration(
                  border: Border.all(
                      color: Colors.black,
                      width: 2
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.history, size: 50,),
                      Text("History", style: smallStyle,),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.star_border_rounded, size: 50,),
                      Text("Saved", style: smallStyle),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.settings_outlined, size: 50,),
                      Text("Settings", style: smallStyle),
                    ],
                  ),
                ],
              )
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(field, style: emphStyle),
        Text(entry, style: ordinaryStyle),
      ],
    );
  }
}