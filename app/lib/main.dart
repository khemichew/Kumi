import 'package:app/tabs/login/profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:app/tabs/memberships/landing_page.dart';
import 'package:app/tabs/explore/landing_page.dart';
import 'package:app/tabs/track/landing_page.dart';
import 'package:app/tabs/login/login_page.dart';

import 'config/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [Locale('en', "EN")],
      debugShowCheckedModeBanner: false,
      title: 'DRP 27',
      home: const MyHomePage(),
      theme: ThemeData(fontFamily: 'Overpass'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  User? user;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }

    return firebaseApp;
  }

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
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: mainBuilder,
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
            label: 'Track',
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

  Widget mainBuilder(BuildContext contexts, AsyncSnapshot<FirebaseApp> snapshot) {
    final List<Widget> widgetOptions = <Widget>[
      const MembershipPage(),
      const Explore(),
      const Track(),
      ProfilePage(user: user!),
    ];

    return Center(
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromRGBO(173, 190, 216, 1),
                Color.fromRGBO(255, 229, 205, 1),
              ],
            )),
        child: Center(
          child: widgetOptions.elementAt(_selectedIndex),
        ),
      ),
    );
  }
}
