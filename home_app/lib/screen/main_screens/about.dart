import 'package:flutter/material.dart';
import 'package:home_app/core/theme/app_theme.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "About Us",
          style: theme.typography.bodyMedium,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Image

            Image.asset(
              'assets/images/rent.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),

            const SizedBox(height: 20),
            // Introduction Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    "Welcome to Your Home Rental App",
                    maxLines: 10,
                    style: theme.typography.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "We connect people with their dream homes effortlessly. Whether you're looking for a cozy apartment or a spacious house, we've got you covered. Explore a wide range of rental properties tailored to suit every lifestyle and budget.",
                    style: theme.typography.titleSmall,
                    maxLines: 50,
                  ),
                  const SizedBox(height: 30),
                  // Mission Section
                  Row(
                    children: [
                      Icon(Icons.emoji_objects,
                          color: Colors.amber[700], size: 32),
                      const SizedBox(width: 10),
                      Text(
                        "Our Mission",
                        style: theme.typography.headlineMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "To revolutionize the house rental experience by offering seamless, reliable, and innovative solutions.",
                    maxLines: 50,
                    style: theme.typography.titleSmall,
                  ),
                  const SizedBox(height: 30),
                  // Vision Section
                  Row(
                    children: [
                      Icon(Icons.visibility,
                          color: Colors.indigo[400], size: 32),
                      const SizedBox(width: 10),
                      Text(
                        "Our Vision",
                        style: theme.typography.headlineMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "To become the leading platform for rental properties, creating a world where everyone finds their perfect home.",
                    style: theme.typography.titleSmall,
                    maxLines: 50,
                  ),
                  const SizedBox(height: 30),
                  // Values Section
                  Row(
                    children: [
                      const Icon(Icons.favorite,
                          color: Colors.redAccent, size: 32),
                      const SizedBox(width: 10),
                      Text(
                        "Our Values",
                        style: theme.typography.headlineMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(Icons.check, color: Colors.green[600]),
                        title: Text(
                          "Customer First",
                          style: theme.typography.titleSmall,
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.check, color: Colors.green[600]),
                        title: Text(
                          "Transparency",
                          style: theme.typography.titleSmall,
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.check, color: Colors.green[600]),
                        title: Text(
                          "Innovation",
                          style: theme.typography.titleSmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Contact Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.primary.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blueGrey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Get in Touch",
                          style: theme.typography.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "📧 Email: netpulse@gmail.com",
                          style: theme.typography.bodyMedium,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "📞 Phone: +251-96-157-6532",
                          style: theme.typography.bodyMedium,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "📍 Address: Addis Ababa, Ethiopia",
                          maxLines: 10,
                          style: theme.typography.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
