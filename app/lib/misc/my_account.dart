import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/config/style.dart';

// import 'models/fake_spend_record.dart';
import '../models/fake_user.dart';

final recordEntries =
    FirebaseFirestore.instance.collection("test-spend-record");

class MyAccountPage extends StatelessWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 60, 20, 0),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
          Text(
            'My\naccount',
            style: largeTitleStyle,
          ),
          // Image(image: AssetImage('../asset/dingzhen_cute.jpeg'))
          CircleAvatar(
            backgroundImage: AssetImage('assets/dingzhen_cute.jpeg'),
            radius: 60,
          )
        ]),
        const SizedBox(height: 30),
        Align(
            alignment: Alignment.topLeft,
            child: StreamBuilder<QuerySnapshot>(
                stream: fakeUserEntries.get().asStream(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Something went wrong"));
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: Text("No entries found"));
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    final data = snapshot.requireData;
                    //print(data.docs[2].id);
                    final user = data.docs[0].data() as FakeUser;

                    return _FakeUserItem(user);
                  }

                  return const Center(child: CircularProgressIndicator());
                })),
        const SizedBox(height: 50),
        Container(
            height: 80,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.history,
                      size: 50,
                    ),
                    Text(
                      "History",
                      style: smallStyle,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.star_border_rounded,
                      size: 50,
                    ),
                    Text("Saved", style: smallStyle),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.settings_outlined,
                      size: 50,
                    ),
                    Text("Settings", style: smallStyle),
                  ],
                ),
              ],
            )),
        // SizedBox(
        //   width: 300,
        //   height:50,
        //   child: FutureBuilder<QuerySnapshot>(
        //       future: fakeSpendRecordEntries.get(),
        //       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //         if (snapshot.hasError) {
        //           return const Center(child: Text("Something went wrong"));
        //         }
        //
        //         if (!snapshot.hasData) {
        //           return const Center(child: Text("No entries found"));
        //         }
        //
        //         if (snapshot.connectionState == ConnectionState.done) {
        //           final data = snapshot.requireData;
        //           // final records = data.docs as List<FakeSpendRecord>;
        //           print(data.docs.length);
        //           return
        //             ListView.builder(
        //               padding: const EdgeInsets.all(15.0),
        //               itemCount:10,
        //               itemBuilder: (context, index) {
        //                 return _SingleRecord(data.docs[index].data() as FakeSpendRecord);
        //               },
        //             );
        //         }
        //
        //         return const Center(child: CircularProgressIndicator());
        //       }),
        // )
      ]),
    );
  }
}
//


class _FakeUserItem extends StatelessWidget {
  final FakeUser fakeUser;

  const _FakeUserItem(this.fakeUser);

  Widget get name {
    return Text(fakeUser.name, style: ordinaryStyle);
  }

  Widget get emailAddress {
    return Text(fakeUser.emailAddress, style: ordinaryStyle);
  }

  Widget get phoneNumber {
    return Text(fakeUser.phoneNumber.toString(), style: ordinaryStyle);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Align(
          alignment: Alignment.topLeft,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Name",
                  style: emphStyle,
                ),
                name,
              ])),
      const SizedBox(height: 30),
      Align(
          alignment: Alignment.topLeft,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Email Address",
                  style: emphStyle,
                ),
                emailAddress,
              ])),
      const SizedBox(height: 30),
      Align(
          alignment: Alignment.topLeft,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Phone Number",
                  style: emphStyle,
                ),
                phoneNumber,
              ])),
    ]);
  }
}