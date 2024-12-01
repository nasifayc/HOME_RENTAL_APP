import 'package:flutter/material.dart';

class StarRatingWidget extends StatelessWidget {
  final double rating; // The float rating between 0.0 and 5.0
  final double starSize; // The size of each star
  final Color filledColor; // Color for filled stars
  final Color unfilledColor; // Color for unfilled stars

  const StarRatingWidget({
    Key? key,
    required this.rating,
    this.starSize = 24.0,
    this.filledColor = Colors.yellow,
    this.unfilledColor = Colors.grey,
  })  : assert(rating >= 0.0 && rating <= 5.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starFraction = (rating - index).clamp(0.0, 1.0);
        return Icon(
          starFraction == 1.0
              ? Icons.star // Fully lit star
              : starFraction > 0.0
                  ? Icons.star_half // Half-lit star
                  : Icons.star_border, // Unlit star
          size: starSize,
          color: starFraction > 0 ? filledColor : unfilledColor,
        );
      }),
    );
  }
}
