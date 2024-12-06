import 'dart:convert';
import 'package:home_app/core/api_url.dart';

import 'package:flutter/material.dart';
import 'package:home_app/core/theme/app_theme.dart';
import 'package:home_app/model/house_model.dart';
import 'package:home_app/screen/layout/sign_up_page.dart';
import 'package:home_app/screen/main_screens/chat_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HouseDetailScreen extends StatefulWidget {
  final HouseModel house;

  const HouseDetailScreen({super.key, required this.house});

  @override
  State<HouseDetailScreen> createState() => _HouseDetailScreenState();
}

class _HouseDetailScreenState extends State<HouseDetailScreen> {
  String? userid;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  Future<void> getUserId() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString("accessToken");

    if (token != null) {
      try {
        final parts = token.split('.');
        if (parts.length == 3) {
          final payload =
              utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
          final payloadMap = jsonDecode(payload); // Convert payload to JSON map
          setState(() {
            userid = payloadMap['id']; // Extract user ID from payload
          });
        }
      } catch (e) {
        print('Error decoding JWT: $e');
      }
    }
    setState(() {
      isLoading = false; // Mark loading as complete
    });
  }

  @override
  Widget build(BuildContext context) {
    AppTheme appTheme = AppTheme.of(context);
    final bool isOwner = userid == widget.house.ownerId;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "House Details",
          style: appTheme.typography.headlineSmall,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // Main image at the top
                Image.network(
                  "$baserURL/${widget.house.mainImage}",
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),

                // Title and location
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    widget.house.title,
                    style: appTheme.typography.headlineMedium,
                  ),
                ),
                const SizedBox(height: 8),
                _buildLocationRow(widget.house.location),
                const SizedBox(height: 16),

                // Price and Rent status
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Text(
                        '${widget.house.price} Birr',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        widget.house.forRent ? 'For Rent' : 'For Sale',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: widget.house.forRent
                              ? Colors.orange[600]
                              : Colors.blue[600],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Category and Owner Details in a card
                _buildHouseDetailsCard(),

                const SizedBox(height: 16),

                // Description Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Description:',
                    style: appTheme.typography.titleMedium,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    widget.house.description,
                    style: appTheme.typography.bodySmall,
                  ),
                ),
                const SizedBox(height: 16),

                // Gallery Section
                _buildGallerySection(),
              ],
            ),
      bottomNavigationBar: !isOwner && !isLoading
          ? _buildBottomNavigation(context)
          : const SizedBox(),
    );
  }

  Widget _buildLocationRow(String location) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              location,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHouseDetailsCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow(Icons.category, 'Category: ${widget.house.category}'),
            _buildRow(Icons.bed, 'Bedrooms: ${widget.house.numberOfBedrooms}'),
            _buildRow(
                Icons.bathtub, 'Bathrooms: ${widget.house.numberOfBathrooms}'),
            _buildRow(Icons.house, 'Floors: ${widget.house.numberOfFloors}'),
          ],
        ),
      ),
    );
  }

  Widget _buildGallerySection() {
    if (widget.house.subImages.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Gallery:',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.house.subImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(widget.house.subImages[index]),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomNavItem(
            icon: Icons.phone,
            label: "Call",
            onTap: () {
              // Add call logic here
            },
          ),
          _buildBottomNavItem(
            icon: Icons.message,
            label: "Message",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => userid == null
                      ? const LoginPage()
                      : ChatDetailScreen(
                          id: widget.house.ownerId,
                          userid: userid!,
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.black, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
