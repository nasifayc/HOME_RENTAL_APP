import 'package:home_app/model/house_model.dart';

class StaticData {
  static List<HouseModel> demoHouses() {
    return const [
      HouseModel(
        title: 'Modern Apartment in Downtown',
        mainImage: 'assets/images/h1.jpg',
        subImages: [
          'assets/images/h1.jpg',
          'assets/images/h2.jpg',
        ],
        location: 'Downtown, City Center',
        description:
            'A beautiful modern apartment with 2 bedrooms and a stunning view of the city skyline.',
        price: 1200.00,
        forSell: false, // For Rent
        owner: 'John Doe',
      ),
      HouseModel(
        title: 'Luxury Villa in the Hills',
        mainImage: 'assets/images/h2.jpg',
        subImages: [
          'assets/images/h1.jpg',
          'assets/images/h2.jpg',
        ],
        location: 'Hilltop, Green Valley',
        description:
            'A stunning 5-bedroom villa with an infinity pool and a large garden.',
        price: 350000.00,
        forSell: true, // For Sale
        owner: 'Jane Smith',
      ),
      HouseModel(
        title: 'Spacious Studio Near the Beach',
        mainImage: 'assets/images/h1.jpg',
        subImages: [
          'assets/images/h1.jpg',
          'assets/images/h2.jpg',
        ],
        location: 'Beachfront, Seaside City',
        description:
            'A cozy studio apartment just a few steps away from the beach, perfect for singles or couples.',
        price: 800.00,
        forSell: false, // For Rent
        owner: 'Alex Johnson',
      ),
      HouseModel(
        title: 'Contemporary Townhouse in Suburbs',
        mainImage: 'assets/images/h2.jpg',
        subImages: [
          'assets/images/h2.jpg',
          'assets/images/h2.jpg',
        ],
        location: 'Suburban Area, Greenfield',
        description:
            'A charming 3-bedroom townhouse with a spacious backyard and close proximity to schools and parks.',
        price: 220000.00,
        forSell: true, // For Sale
        owner: 'Emily White',
      ),
      HouseModel(
        title: 'Charming Cottage in Countryside',
        mainImage: 'assets/images/h1.jpg',
        subImages: [
          'assets/images/h1.jpg',
          'assets/images/h1.jpg',
        ],
        location: 'Countryside, Rosewood',
        description:
            'A cozy 2-bedroom cottage with a garden and a peaceful rural setting, perfect for a weekend getaway.',
        price: 90000.00,
        forSell: true, // For Sale
        owner: 'Michael Brown',
      ),
    ];
  }
}
