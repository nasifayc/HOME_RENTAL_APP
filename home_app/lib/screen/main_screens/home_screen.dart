import 'package:flutter/material.dart';
import 'package:home_app/core/theme/app_theme.dart';
import 'package:home_app/widget/common/form_components.dart';
import 'package:home_app/widget/home/carousel_image.dart';
import 'package:home_app/widget/home/categories.dart';
import 'package:home_app/widget/home/popular_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    FormComponents formComponents = FormComponents(context: context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CarouselImage(),
            const SizedBox(height: 20),
            formComponents.buildSearchBar(_searchController, 'Search', true),
            const SizedBox(height: 20),
            Text(
              'Categories',
              style:
                  theme.typography.titleMedium.copyWith(color: theme.primary),
            ),
            const SizedBox(height: 10),
            const Categories(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular',
                  style: theme.typography.titleMedium
                      .copyWith(color: theme.primary),
                ),
                Text(
                  'See all',
                  style: theme.typography.bodySmall,
                )
              ],
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 230, child: PopularSection()),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'For Sell',
                  style: theme.typography.titleMedium
                      .copyWith(color: theme.primary),
                ),
                Text(
                  'See all',
                  style: theme.typography.bodySmall,
                )
              ],
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 230, child: PopularSection()),
          ],
        ),
      ),
    );
  }
}
