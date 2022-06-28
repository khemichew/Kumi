import 'package:kumi/config/style.dart';
import 'package:kumi/models/deal_ratings.dart';
import 'package:kumi/models/deals.dart';
import 'package:kumi/tabs/explore/deal_dialog.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

enum DealQuery {
  nameAsc,
  nameDesc,
  priceAsc,
}

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
      tempQuery = dealEntries.orderBy('name',
          descending: queryType == DealQuery.nameDesc);
    } else if (queryType == DealQuery.priceAsc) {
      tempQuery = dealEntries.orderBy('discountedPrice');
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
              onSelected: (value) =>
                  setState(() {
                    queryType = value;
                    updateQuery(queryText);
                  }),
              icon: const Icon(Icons.filter_alt_rounded),
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                      value: DealQuery.nameAsc, child: Text("Name ⬆")),
                  const PopupMenuItem(
                    value: DealQuery.nameDesc,
                    child: Text("Name ⬇"),
                  ),
                  const PopupMenuItem(
                    value: DealQuery.priceAsc,
                    child: Text("Price ⬆"),
                  ),
                ];
              })
      ),

      focusNode: _textFieldFocus,
      // Query when text field changes
      onChanged: _onSearchChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text(
              'Explore deals',
              style: titleStyle,
            ),
            elevation: 0
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
                child: _searchBar(),
              ),
              Expanded(
                  child: StreamBuilder<QuerySnapshot<Deal>>(
                      stream: queryStream as Stream<QuerySnapshot<Deal>>,
                      builder:
                          (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text("Something went wrong"));
                        }

                        if (!snapshot.hasData) {
                          return const Center(child: Text("Loading..."));
                        }

                        final data = snapshot.requireData;

                        return ListView.builder(
                          padding: const EdgeInsets.all(15.0),
                          itemCount: data.size,
                          itemBuilder: (context, index) {
                            final entry = data.docs[index];
                            return _DealsItem(
                                entry.data() as Deal,
                                entry.reference as DocumentReference<Deal>);
                          },
                        );
                      }
                  )
              )
            ]
        )
    );
  }
}

class _DealsItem extends StatelessWidget {
  final Deal deal;
  final DocumentReference<Deal> dealDocRef;
  final NumberFormat formatCurrency =
  NumberFormat.currency(locale: "en_GB", symbol: "£");

  _DealsItem(this.deal, this.dealDocRef);

  Widget get productName {
    return Text(deal.name,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.fade,
        ),
        maxLines: 2,
        softWrap: false);
  }

  Widget get image {
    return AspectRatio(
        aspectRatio: 3.0,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                alignment: FractionalOffset.topCenter,
                image: NetworkImage(deal.imageUrl),
              )),
        ));
  }

  // need to retrieve retailer from database
  Widget get ratingSummaryAndRetailer {
    return StreamBuilder<QuerySnapshot<DealRating>>(
        stream: dealRatingEntries.where('dealId', isEqualTo: dealDocRef.id)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          Widget defaultDisplay = Text("No rating ·  ${deal.retailerId}");

          if (snapshot.hasError || !snapshot.hasData) return defaultDisplay;

          final data = snapshot.requireData.docs;
          if (data.isEmpty) return defaultDisplay;

          final ratingSum = data.fold(0, (prev, elem) => (prev as num) +
              (elem.data() as DealRating).rating);
          final averageRating = ratingSum / data.length;
          final trimmedRating = averageRating.toStringAsPrecision(2);

          return Text("$trimmedRating★ (${data.length} review(s)) ·  ${deal.retailerId}");
        }
    );
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
          TableRow(children: [ratingSummaryAndRetailer, discountedPrice])
        ]);
  }

  dynamic onTapBehaviour(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return DealDialog(deal, dealDocRef);
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


