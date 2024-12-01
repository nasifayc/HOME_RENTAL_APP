import 'package:flutter/material.dart';
import 'package:home_app/core/theme/app_theme.dart';

class ShopCoin extends StatelessWidget {
  const ShopCoin({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> coinPackages = [
      {'coins': 1, 'price': 1},
      {'coins': 10, 'price': 7},
      {'coins': 50, 'price': 30},
      {'coins': 100, 'price': 70},
      {'coins': 500, 'price': 300},
      {'coins': 1000, 'price': 800},
      {'coins': 10000, 'price': 5000},
    ];

    AppTheme theme = AppTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Shop'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: coinPackages.length,
        itemBuilder: (context, index) {
          final package = coinPackages[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            child: ListTile(
              leading: SizedBox(
                width: 40,
                child: Stack(
                  children: List.generate(
                    (package['coins'] / 50).clamp(1, 6).toInt(),
                    (i) => Positioned(
                      bottom: i * 2,
                      left: i * 1.03,
                      child: const Icon(
                        Icons.monetization_on_outlined,
                        color: Colors.amber,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(
                '${package['coins']} Coins',
                style: theme.typography.titleMedium,
              ),
              subtitle: Text('${package['price']} ETB',
                  style: theme.typography.bodyMedium),
              trailing: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: theme.primaryBackground,
                      title: Text(
                        'Purchase Successful',
                        style: theme.typography.headlineSmall,
                      ),
                      content: Text(
                        'You have purchased ${package['coins']} coins for ${package['price']} ETB.',
                        style: theme.typography.titleSmall,
                        maxLines: 10,
                      ),
                      actions: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Center(
                            child: Text(
                              'OK',
                              style: theme.typography.headlineSmall,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Buy',
                  style: theme.typography.labelSmall,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
