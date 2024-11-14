import 'package:flutter/material.dart';
import 'package:home_app/core/theme/app_theme.dart';
import 'package:home_app/widget/common/secondary_button.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    // List of categories
    final List<String> categories = [
      'Apartments',
      'Villas',
      'Studios',
      'Townhouses',
      'Penthouses',
      'Duplexes',
    ];

    return SizedBox(
      height: 40, // Adjust height based on button size
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SecondaryButton(
                onPressed: null,
                color: Theme.of(context).primaryColor,
                child: Text(
                  categories[index],
                  style: theme.typography.labelMedium.copyWith(
                      color: theme.primary, fontWeight: FontWeight.normal),
                )),
          );
        },
      ),
    );
  }
}
