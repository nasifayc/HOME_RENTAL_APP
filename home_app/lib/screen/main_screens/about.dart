import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text(
          "About Us",
          style: TextStyle(fontWeight: FontWeight.bold),
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
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[900],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "We connect people with their dream homes effortlessly. Whether you're looking for a cozy apartment or a spacious house, we've got you covered. Explore a wide range of rental properties tailored to suit every lifestyle and budget.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
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
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "To revolutionize the house rental experience by offering seamless, reliable, and innovative solutions.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
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
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "To become the leading platform for rental properties, creating a world where everyone finds their perfect home.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Values Section
                  Row(
                    children: [
                      Icon(Icons.favorite, color: Colors.redAccent, size: 32),
                      const SizedBox(width: 10),
                      Text(
                        "Our Values",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800],
                        ),
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
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.check, color: Colors.green[600]),
                        title: Text(
                          "Transparency",
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.check, color: Colors.green[600]),
                        title: Text(
                          "Innovation",
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Contact Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blueGrey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Get in Touch",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[800],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "📧 Email: contact@yourapp.com",
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "📞 Phone: +1 234 567 890",
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "📍 Address: 123 Dream Street, Hometown, Country",
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
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
