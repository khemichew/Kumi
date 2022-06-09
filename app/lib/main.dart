import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
      title: _title,
      home: MyHomePage(title: _title),
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

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const TextStyle titleStyle =
  TextStyle(fontSize: 24, fontWeight: FontWeight.w500);

  static const TextStyle ordinaryStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.w400);

  final List<Widget> _widgetOptions = <Widget>[
    const MembershipPage(),
    const Text(
      'Index 1: Explore',
      style: optionStyle,
    ),
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
      margin: const EdgeInsets.fromLTRB(20, 45, 20, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'My\naccount',
                style: _MyHomePageState.titleStyle,
              ),
            ]
          ),
        ]
      ),
    );
  }
}

class MembershipPage extends StatelessWidget {
  const MembershipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 45, 20, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My\nmemberships',
                style: _MyHomePageState.titleStyle,
              ),
              Container(
                decoration:BoxDecoration(
                  border: Border.all(
                    color: Colors.black
                  ),
                  color: Colors.white38,
                  borderRadius: const BorderRadius.all(Radius.circular(10))
                ),
                child:TextButton(
                  onPressed: () {  },
                  child: SizedBox(
                    width: 120,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Add", style: _MyHomePageState.ordinaryStyle),
                        Icon(Icons.add)
                      ],
                    ),
                  ),
                ),
              ),
            ]
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              MembershipCard(storeName: 'Store A', color: Color.fromRGBO(255, 191, 0, 0.5),),
              MembershipCard(storeName: 'Store B', color: Color.fromRGBO(248, 152, 128, 0.5),),
            ]
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              MembershipCard(storeName: 'Store C', color: Color.fromRGBO(137, 207, 240, 0.5),),
              MembershipCard(storeName: 'Store D', color: Color.fromRGBO(115, 113, 255, 0.5),),
            ]
          )
        ],
      ),
    );
  }
}

class MembershipCard extends StatelessWidget {
  const MembershipCard({Key? key, required this.storeName, required this.color}) : super(key: key);
  
  final String storeName;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(10))
      ),
      child: TextButton(
        onPressed: () {  },
        child: Container(
          width: 120,
          height: 100,
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(storeName, style: _MyHomePageState.ordinaryStyle),
                  const Icon(Icons.chevron_right)
                ]
              ),
              // const Icon(Icons.card_membership)
            ],
          ),
        ),
      ),
    );
  }
}
