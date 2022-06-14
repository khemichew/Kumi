import 'package:app/style.dart';
import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  static const int displayLimit = 20;

  @override
  Widget build(BuildContext context) {


    return Container(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
        child: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
              pinned: true,
              floating: true,
              snap: false,
              centerTitle: false,
              expandedHeight: 100.0,
              title: const Text('Explore Deals', style: titleStyle, textScaleFactor: 1.3),
              backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
              bottom: AppBar(
                backgroundColor:  const Color.fromRGBO(0, 0, 0, 0),
                  title: Container(
                      width: double.infinity,
                      height: 40,
                      color: Colors.white,
                      child: const Center(
                          child: TextField(
                              style: ordinaryStyle,
                              decoration: InputDecoration(
                                  hintText: 'Search...',
                                  prefixIcon: Icon(Icons.search))))))),
          // Add deal entries
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Container(
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: getRandomPastelColour(),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Text(
                    'Deal $index',
                    textScaleFactor: 3,
                  ));
            }, childCount: displayLimit),
          )
        ]));
  }
}
