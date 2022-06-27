import 'package:app/config/style.dart';
import 'package:flutter/material.dart';
import 'package:app/models/deals.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DealDialog extends StatelessWidget {
  final Deal deal;

  const DealDialog(this.deal, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(
          deal.name,
          style: emphStyle,
        ),
        content: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Store: ${deal.retailerId}\n",
                    style: smallStyle,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Description: ${deal.description}\n",
                    style: smallStyle,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Original Price:  ${deal.retailPrice}\n",
                    style: smallStyle,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Current Price:  ${deal.discountedPrice}\n",
                    style: smallStyle,
                  ),
                ),
                Row(
                  children: [
                    const Text("Rate:"),
                    const Spacer(),
                    rating
                  ]
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "\nDiscount:  ${percentOff(deal.retailPrice, deal.discountedPrice)}% OFF!!!",
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
    // print("prev: ${prev}, curr: ${curr}, ratio: ${ratio}");
    return (ratio * 100).toStringAsFixed(1);
  }

  Widget get rating {
    return RatingBar.builder(
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) => const Icon(
        Icons.star,
        color: Colors.amber
      ),
      onRatingUpdate: (double value) {  },
    );
  }
}