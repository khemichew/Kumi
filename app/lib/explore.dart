import 'package:app/models/deals.dart';
import 'package:app/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

enum DealQuery { nameAsc, nameDesc, ratingDesc, }

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  late String queryText;
  late Stream queryStream;
  late FocusNode _textFieldFocus;
  Timer? _debounce;
  static const displayLimit = 20;
  Color _color = Colors.black12;
  DealQuery queryType = DealQuery.nameAsc;

  @override
  void initState() {
    queryText = "";
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
    queryStream = dealEntries.limit(displayLimit).snapshots();
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }


  void updateQuery(String query) {
    Query<Deal> tempQuery;
    if (queryType == DealQuery.nameAsc || queryType == DealQuery.nameDesc) {
        tempQuery = dealEntries.orderBy('name', descending: queryType == DealQuery.nameDesc);
    } else if (queryType == DealQuery.ratingDesc) {
      tempQuery = dealEntries.orderBy('rating', descending: queryType == DealQuery.ratingDesc);
    } else {
      tempQuery = dealEntries.orderBy('name');
    }

    queryText = query;
    if (queryText.isEmpty || queryText
        .trim()
        .isEmpty) {
      queryStream = tempQuery.limit(displayLimit).snapshots();
    } else {
      queryStream = tempQuery
          .where('name', isGreaterThanOrEqualTo: queryText)
          .where('name', isLessThan: '$queryText\uf8ff')
          .limit(displayLimit)
          .snapshots();
    }
  }

  dynamic _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      updateQuery(query);
    });
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
          prefixIcon: const Icon(Icons.search),
          suffixIcon: PopupMenuButton<DealQuery>(
              onSelected: (value) => setState(() {
                queryType = value;
                updateQuery(queryText);
              }),
              icon: const Icon(Icons.filter_alt_rounded),
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                      value: DealQuery.nameAsc,
                      child: Text("Name ⬆")
                  ),
                  const PopupMenuItem(
                    value: DealQuery.nameDesc,
                    child: Text("Name ⬇"),
                  ),
                  const PopupMenuItem(
                    value: DealQuery.ratingDesc,
                    child: Text("Rating ⬇"),
                  ),
                ];
              }
          )),

      focusNode: _textFieldFocus,
      // Query when text field changes
      onChanged: _onSearchChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white, title: _searchBar(), elevation: 0),
        body: StreamBuilder<QuerySnapshot<Deal>>(
            stream: queryStream as Stream<QuerySnapshot<Deal>>,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text("Something went wrong"));
              }

              if (!snapshot.hasData) {
                return const Center(child: Text("No entries found"));
              }

              final data = snapshot.requireData;

              return ListView.builder(
                padding: const EdgeInsets.all(15.0),
                itemCount: data.size,
                itemBuilder: (context, index) {
                  return _DealsItem(data.docs[index].data() as Deal);
                },
              );
            }));
  }
}

class _DealsItem extends StatelessWidget {
  final Deal deal;
  final NumberFormat formatCurrency =
  NumberFormat.currency(locale: "en_GB", symbol: "£");

  _DealsItem(this.deal);

  // TODO: add trailing ... if too long
  Widget get productName {
    return Text(deal.name,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget get image {
    return AspectRatio(
        aspectRatio: 3.0,
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                alignment: FractionalOffset.topCenter,
                image: AssetImage('assets/images/food-placeholder.jpg'),
              )),
        ));
  }

  // TODO: retrieve from database
  Widget get retailer {
    return const Text("Tesco Express");
  }

  Widget get retailPrice {
    return Align(
        alignment: Alignment.bottomRight,
        child: Text(formatCurrency.format(deal.retailPrice),
            style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w100,
                decoration: TextDecoration.lineThrough)));
    // return
  }

  Widget get discountedPrice {
    return Align(
        alignment: Alignment.bottomRight,
        child: Text(formatCurrency.format(deal.discountedPrice),
            style: const TextStyle(fontWeight: FontWeight.bold)));
  }

  Widget get details {
    return Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(),
          1: IntrinsicColumnWidth()
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
        children: [
          TableRow(children: [productName, retailPrice]),
          TableRow(children: [retailer, discountedPrice])
        ]);
  }

  dynamic onTapBehaviour(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return DealDialog(deal);
        });
  }

  @override
  Widget build(BuildContext context) {
    const SizedBox pad = SizedBox(height: 8);

    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          onTapBehaviour(context);
        },
        child: Column(children: [image, pad, details, pad]));
  }
}

class DealDialog extends StatelessWidget {
  final Deal deal;

  const DealDialog(this.deal, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(deal.name, style: emphStyle,),
        content: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children :[
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text("Store: Sainsbury", style: ordinaryStyle,),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(deal.description, style: ordinaryStyle,),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Original Price: ${deal.retailPrice},", style: ordinaryStyle,),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Current Price: ${deal.discountedPrice}\n\n", style: ordinaryStyle,),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text("Discount: ${percentOff(deal.retailPrice, deal.discountedPrice)}% OFF!!!", style: emphStyle,),
                    ),
                  ]
              ),
            )));
  }

  String percentOff(num original, num current) {
    double prev = original.toDouble();
    double curr = current.toDouble();
    double ratio = (prev - curr) / prev;
    // print("prev: ${prev}, curr: ${curr}, ratio: ${ratio}");
    return (ratio * 100).toStringAsFixed(1);
  }

}
