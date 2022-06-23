import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:provider/provider.dart';

import 'package:app/config/firebase_options.dart';
import 'package:app/config/style.dart';

import 'package:app/models/cached_entries.dart';
import 'package:app/models/card_options.dart';

import 'package:app/tabs/memberships/landing_page.dart';
import 'package:app/tabs/explore/landing_page.dart';
import 'package:app/tabs/track/landing_page.dart';
import 'package:app/tabs/login/login_page.dart';
import 'package:app/tabs/records/landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider<CachedEntries<CardOption>>(
      create: (_) => CachedEntries<CardOption>(databaseInstance: cardOptions),
      child: const MyApp()));
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
  State<MyHomePage> createState()  {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget get navBar {
    return BottomNavigationBar(
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
          label: 'Analyse',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'Record',
        ),
      ],
      currentIndex: _selectedIndex,
      backgroundColor: champaignGold,
      selectedItemColor: navyBlue,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return homeBuilder(user: snapshot.requireData);
        } else {
          return const LoginPage();
        }
      }
    );
  }

  Widget homeBuilder({User? user}) {
    final List<Widget> widgetOptions = <Widget>[
      const MembershipPage(),
      const Explore(),
      const Track(),
      const Record(),
      // ProfilePage(user: user!),
    ];

    return Scaffold(
      body: Center(
        child: Container(
          decoration: pageDecoration,
          child: Center(
            child: widgetOptions.elementAt(_selectedIndex),
          ),
        ),
      ),
      bottomNavigationBar: navBar
    );
  }
}
