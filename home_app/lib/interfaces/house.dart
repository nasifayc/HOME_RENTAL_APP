import 'package:dartz/dartz.dart';
import 'package:home_app/model/house_model.dart';
import 'package:home_app/states/house_state.dart';
import 'package:image_picker/image_picker.dart';

abstract class IHouseRepository {
  Future<Either<List<HouseModel>?, HouseError?>> fetchHouses();
  Future<Either<List<HouseModel>?, HouseError?>> addHouse(
      String title,
      String location,
      String description,
      num price,
      String category,
      num bedrooms,
      num bathrooms,
      num floors,
      bool forRent,
      XFile mainIMage,
      List<XFile> subImages);
}
