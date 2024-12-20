import 'package:flutter/material.dart';
import 'package:home_app/core/theme/app_theme.dart';
import 'package:home_app/model/house_model.dart';
import 'package:home_app/widget/home/home_card.dart';

class PopularSection extends StatelessWidget {
  final List<HouseModel> houses;
  const PopularSection({super.key, required this.houses});

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);

    if (houses.length > 0) {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: houses.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: HomeCard(house: houses[index]),
          ); // Pass the house to HomeCard
        },
      );
    } else {
      return SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off,
              size: 100,
            ),
            Text(
              "No Result",
              style: TextStyle(fontSize: 20, color: theme.primaryText),
            )
          ],
        ),
      );
    }
  }
}
