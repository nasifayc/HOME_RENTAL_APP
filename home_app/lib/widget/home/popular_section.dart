import 'package:flutter/material.dart';
import 'package:home_app/model/house_model.dart';
import 'package:home_app/utils/static_data.dart';
import 'package:home_app/widget/home/home_card.dart';

class PopularSection extends StatelessWidget {
  const PopularSection({super.key});

  @override
  Widget build(BuildContext context) {
    List<HouseModel> houses = StaticData.demoHouses();

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: houses.length, // The number of houses
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: HomeCard(house: houses[index]),
        ); // Pass the house to HomeCard
      },
    );
  }
}
