import 'package:flutter/material.dart';
import 'package:home_app/core/theme/app_theme.dart';
import 'package:home_app/model/house_model.dart';

class HomeDetailScreen extends StatelessWidget {
  final HouseModel houseModel;
  const HomeDetailScreen({super.key, required this.houseModel});

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Detail',
          style: theme.typography.titleMedium,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // House image container
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(houseModel.mainImage),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
              ),
              // House title and price
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      houseModel.title,
                      style: theme.typography.headlineMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '\$${houseModel.price}',
                      style: theme.typography.titleLarge.copyWith(
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      houseModel.description,
                      style: theme.typography.bodyLarge.copyWith(
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Location: ${houseModel.location}',
                      style: theme.typography.bodyMedium.copyWith(
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.account_circle,
                          color: theme.primary,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Owner: ${houseModel.owner}',
                          style: theme.typography.bodyMedium.copyWith(
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Display whether the house is for rent or for sale
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: houseModel.forSell ? Colors.green : Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        houseModel.forSell ? 'For Sale' : 'For Rent',
                        style: theme.typography.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Sub images carousel can be added here in the future
            ],
          ),
        ),
      ),
    );
  }
}
