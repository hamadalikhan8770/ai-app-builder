import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.rating, this.count});
  final double rating;
  final int? count;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (var i = 1; i <= 5; i++)
        Icon(
          i <= rating.round() ? Icons.star : Icons.star_border,
          size: 18,
          color: Colors.amber,
        ),
      if (count != null)
        Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Text('($count)'),
        ),
    ],
  );
}
