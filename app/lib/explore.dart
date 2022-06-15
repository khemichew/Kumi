import 'dart:math';

import 'package:app/models/deals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  late FocusNode _textFieldFocus;
  Color _color = Colors.black12;

  @override
  void initState() {
    _textFieldFocus = FocusNode();
    _textFieldFocus.addListener(() {
      if (_textFieldFocus.hasFocus) {
        setState(() {
          _color = Colors.black26;
        });
      } else {
        setState(() {
          _color = Colors.black12;
        });
      }
    });
    super.initState();
  }

  Widget _searchBar() {
    return TextField(
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            hintText: "Search deals..",
            contentPadding: const EdgeInsets.all(15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.white)),
            filled: true,
            fillColor: _color,
            prefixIcon: const Icon(Icons.search)),
        focusNode: _textFieldFocus
        // Query when text field changes
        // onChanged: ,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white, title: _searchBar(), elevation: 0),
        body: const DealsList());
  }
}

class DealsList extends StatefulWidget {
  const DealsList({Key? key}) : super(key: key);

  @override
  State<DealsList> createState() => _DealsListState();
}

class _DealsListState extends State<DealsList> {
  static const int displayLimit = 20;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: dealEntries.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No entries found"));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            final data = snapshot.requireData;
            return ListView.builder(
              padding: const EdgeInsets.all(15.0),
              itemCount: min(data.size, displayLimit),
              itemBuilder: (context, index) {
                return _DealsItem(data.docs[index].data() as Deal);
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        });
  }
}

class _DealsItem extends StatelessWidget {
  final Deal deal;

  const _DealsItem(this.deal);

  Widget get title {
    return Text(deal.name,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  // TODO: crop
  Widget get image {
    return Image.asset('assets/images/food-placeholder.jpg');
  }

  // Widget get discount {
  //
  // }

  Widget get details {
    return Row(children: [
      Align(
        alignment: Alignment.topLeft,
        child: title,
      ),
      // Align(
      //   alignment: Alignment.topRight,
      //   child:
      // )
      Text("${deal.name} ${deal.description} ${deal.discountedPrice}")
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [image, details]);
  }
}
