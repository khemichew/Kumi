import 'package:app/explore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:app/style.dart';
import 'package:app/memberships.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final String _title = 'DRP 27';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: MyHomePage(title: _title),
      theme: ThemeData(fontFamily: 'Overpass'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const MembershipPage(),
    const Explore(),
    const Text(
      'Index 2: Savings',
      style: optionStyle,
    ),
    const AccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromRGBO(173, 190, 216, 1),
                Color.fromRGBO(255, 229, 205, 1),
              ],
            )
          ),
          child: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Memberships',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_pound_outlined),
            label: 'Savings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'My account',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: const Color.fromRGBO(255, 229, 205, 1),
        selectedItemColor: const Color.fromRGBO(51, 85, 135, 1.0),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

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
                    'My\naccount',
                    style: titleStyle,
                  ),
                ]
            ),
            Row(

              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                PersonalDetail(field: "Name", entry: "Jim Brown")
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
          decoration:const BoxDecoration(
              color: Color.fromRGBO(0,0,0,0),
          ),
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
