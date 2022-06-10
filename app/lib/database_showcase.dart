import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
// import 'package:app/style.dart';

@immutable
class Retailer {
  final String name;
  final String description;
  final int rating;

  const Retailer(
      {required this.name, required this.description, required this.rating});

  Retailer.fromJson(Map<String, Object?> json)
      : this(
            name: json['name']! as String,
            description: json['description']! as String,
            rating: json['rating']! as int);

  Map<String, Object?> toJson() {
    return {'name': name, 'description': description, 'rating': rating};
  }
}

// Instance to database, referencing the list of retailers
// withConverter is used to ensure type-safety
final retailerData = FirebaseFirestore.instance
    .collection('retailer-example')
    .withConverter<Retailer>(
        fromFirestore: (snapshots, _) => Retailer.fromJson(snapshots.data()!),
        toFirestore: (entry, _) => entry.toJson());

// The different ways we can sort/filter entries
enum RetailerQuery { nameAsc, nameDesc, ratingAsc, ratingDesc }

extension on Query<Retailer> {
  // Create a firebase query from a [RetailerQuery]
  Query<Retailer> queryBy(RetailerQuery query) {
    switch (query) {
      case RetailerQuery.nameAsc:
      case RetailerQuery.nameDesc:
        return orderBy('name', descending: query == RetailerQuery.nameDesc);
      case RetailerQuery.ratingAsc:
      case RetailerQuery.ratingDesc:
        return orderBy('rating', descending: query == RetailerQuery.ratingDesc);
    }
  }
}

// Widget that displays the whole list
class RetailerList extends StatefulWidget {
  const RetailerList({Key? key}) : super(key: key);

  @override
  RetailerListState createState() => RetailerListState();
}

class RetailerListState extends State<RetailerList> {
  static const int displayLimit = 20;
  RetailerQuery query = RetailerQuery.nameAsc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Text('Sort by'),
          ],
        ),
        actions: [
          PopupMenuButton<RetailerQuery>(
            onSelected: (value) => setState(() => query = value),
            icon: const Icon(Icons.sort),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: RetailerQuery.nameAsc,
                  child: Text("Name ⬆"),
                ),
                const PopupMenuItem(
                  value: RetailerQuery.nameDesc,
                  child: Text("Name ⬇"),
                ),
                const PopupMenuItem(
                  value: RetailerQuery.ratingAsc,
                  child: Text("Rating ⬆"),
                ),
                const PopupMenuItem(
                  value: RetailerQuery.ratingDesc,
                  child: Text("Rating ⬇"),
                ),
              ];
            },
          ),
        ],
      ),
      // Display query results
      body: StreamBuilder<QuerySnapshot<Retailer>>(
        stream: retailerData.queryBy(query).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;

          // Create list of retailer entries
          return ListView.builder(
            itemCount: min(data.size, displayLimit),
            itemBuilder: (context, index) {
              return _RetailerItem(
                data.docs[index].data(),
                data.docs[index].reference,
              );
            },
          );
        },
      ),
    );
  }
}

class _RetailerItem extends StatelessWidget {
  final Retailer retailer;
  final DocumentReference<Retailer> reference;

  const _RetailerItem(this.retailer, this.reference);

  Widget get title {
    return Text(retailer.name,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget get description {
    return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(retailer.description));
  }

  Widget get rating {
    return Text("Rating: ${retailer.rating} stars");
  }

  Widget get details {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [title, description, rating]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 8, left: 8, right: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Flexible(child: details)],
        ));
  }
}

class AddRetailer extends StatefulWidget {
  const AddRetailer({super.key});

  @override
  AddRetailerState createState() {
    return AddRetailerState();
  }
}

class AddRetailerState extends State<AddRetailer> {
  late String name;
  late String description;
  late int rating;
  final _formKey = GlobalKey<FormState>();

  Widget _displayForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onSaved: (String? value) {
                name = value!;
              },
              decoration: const InputDecoration(labelText: "Name"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onSaved: (String? value) {
                description = value!;
              },
              decoration: const InputDecoration(labelText: "Description"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                onSaved: (String? value) {
                  rating = int.parse(value!);
                },
                decoration: const InputDecoration(labelText: "Rating"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: const Text("Submit"),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState?.save();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Entry added!')),
                  );
                  // save to database
                  retailerData.add(Retailer(
                      name: name, description: description, rating: rating));
                }
              },
            ),
          )
        ]));
  }

  // Show dialog for user to fill in retailer details

  Widget _addEntryButton(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(content: _displayForm(context));
                  });
            },
            child: const Text('Button', style: TextStyle(fontSize: 20))));
  }

  @override
  Widget build(BuildContext context) {
    return _addEntryButton(context);
  }
}

// Entry point.
class DatabaseShowcase extends StatelessWidget {
  const DatabaseShowcase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: const [RetailerList(), AddRetailer()]);
  }
}
