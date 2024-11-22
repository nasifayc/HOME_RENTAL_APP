import 'package:equatable/equatable.dart';

class HouseModel extends Equatable {
  final String title;
  final String mainImage;
  final List<String> subImages;
  final String location;
  final String description;
  final num price;
  final bool forRent;
  final String ownerId;
  final String category;
  final num numberOfBedrooms;
  final num numberOfBathrooms;
  final num numberOfFloors;

  const HouseModel(
      {required this.title,
      required this.mainImage,
      required this.subImages,
      required this.location,
      required this.description,
      required this.price,
      required this.forRent,
      required this.ownerId,
      required this.category,
      required this.numberOfBathrooms,
      required this.numberOfBedrooms,
      required this.numberOfFloors});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'mainImage': mainImage,
      'subImages': subImages,
      'location': location,
      'description': description,
      'price': price,
      'for_rent': forRent,
      'ownerId': ownerId,
      'category': category,
      'number_of_bedrooms': numberOfBedrooms,
      "number_of_bathrooms": numberOfBathrooms,
      "number_of_floors": numberOfFloors
    };
  }

  factory HouseModel.fromJson(Map<String, dynamic> jsonHouse) {
    return HouseModel(
        title: jsonHouse['title'],
        mainImage: jsonHouse['main_image'],
        subImages: List<String>.from(jsonHouse["sub_images"] ?? []),
        location: jsonHouse['location'],
        description: jsonHouse['description'],
        price: jsonHouse['price'],
        forRent: jsonHouse['for_rent'],
        ownerId: jsonHouse['ownerId'],
        numberOfBathrooms: jsonHouse['number_of_bathrooms'],
        numberOfBedrooms: jsonHouse['number_of_bedrooms'],
        numberOfFloors: jsonHouse['number_of_floors'],
        category: jsonHouse['category']);
  }
  @override
  List<Object?> get props => [
        title,
        mainImage,
        subImages,
        location,
        description,
        price,
        forRent,
        ownerId,
        category,
        numberOfBathrooms,
        numberOfBedrooms,
        numberOfFloors
      ];
}
