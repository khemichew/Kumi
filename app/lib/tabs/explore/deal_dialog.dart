import 'package:app/config/style.dart';
import 'package:app/models/deal_ratings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/models/deals.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DealDialog extends StatefulWidget {
  final Deal deal;
  final DocumentReference<Deal> dealDocRef;

  const DealDialog(this.deal, this.dealDocRef, {Key? key}) : super(key: key);

  @override
  State<DealDialog> createState() => _DealDialogState();
}

class _DealDialogState extends State<DealDialog> {
  DocumentReference<DealRating>? ratingDocRef;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(
          widget.deal.name,
          style: emphStyle,
        ),
        content: SingleChildScrollView(
            child: Align(
          alignment: Alignment.topLeft,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Store: ${widget.deal.retailerId}\n",
                style: smallStyle,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Description: ${widget.deal.description}\n",
                style: smallStyle,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Original Price:  ${widget.deal.retailPrice}\n",
                style: smallStyle,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Current Price:  ${widget.deal.discountedPrice}\n",
                style: smallStyle,
              ),
            ),
            Row(children: [const Text("Rate:"), const Spacer(), rating]),
            Align(
              alignment: Alignment.center,
              child: Text(
                "\nDiscount:  ${percentOff(widget.deal.retailPrice, widget.deal.discountedPrice)}% OFF!!!",
                style: emphStyle,
              ),
            ),
          ]),
        )));
  }

  String percentOff(num original, num current) {
    double prev = original.toDouble();
    double curr = current.toDouble();
    double ratio = (prev - curr) / prev;
    return (ratio * 100).toStringAsFixed(1);
  }

  Future<void> getRatingEntry() async {
    final entry = await dealRatingEntries
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('dealId', isEqualTo: widget.dealDocRef.id)
        .get();

    // Query size will only ever be 0 or 1 since entry is unique
    if (entry.size != 0) {
      setState(() {
        ratingDocRef = entry.docs[0].reference;
      });
    }
  }

  Widget get rating {
    return RatingBar.builder(
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) =>
          const Icon(Icons.star, color: Colors.amber),
      onRatingUpdate: (double rating) async {
        // Query for document entry if it is not initialised
        if (ratingDocRef == null) {
          await getRatingEntry();
        }

        // Create new entry if it doesn't exist, else update it
        if (ratingDocRef == null) {
          final entry = DealRating(
              dealId: widget.dealDocRef.id,
              userId: FirebaseAuth.instance.currentUser!.uid,
              rating: rating);
          dealRatingEntries.add(entry);
        } else {
          ratingDocRef!.update({'rating': rating});
        }
      },
    );
  }
}
