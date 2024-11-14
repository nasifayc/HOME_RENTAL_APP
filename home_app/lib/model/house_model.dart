import 'package:equatable/equatable.dart';

class HouseModel extends Equatable {
  final String title;
  final String mainImage;
  final List<String> subImages;
  final String location;
  final String description;
  final double price;
  final bool forSell;
  final String owner;

  const HouseModel(
      {required this.title,
      required this.mainImage,
      required this.subImages,
      required this.location,
      required this.description,
      required this.price,
      required this.forSell,
      required this.owner});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'mainImage': mainImage,
      'subImages': subImages,
      'location': location,
      'description': description,
      'price': price,
      'forSell': forSell,
      'owner': owner,
    };
  }

  factory HouseModel.fromJson(Map<String, dynamic> toJson) {
    return HouseModel(
      title: toJson['title'],
      mainImage: toJson['mainImage'],
      subImages: toJson['subImages'],
      location: toJson['location'],
      description: toJson['description'],
      price: toJson['price'],
      forSell: toJson['forSell'],
      owner: toJson['owner'],
    );
  }
  @override
  List<Object?> get props => [
        title,
        mainImage,
        subImages,
        location,
        description,
        price,
        forSell,
        owner,
      ];
}
