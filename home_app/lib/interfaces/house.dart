import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:home_app/model/house_model.dart';
import 'package:home_app/states/house_state.dart';

abstract class IHouseRepository {
  Future<Either<List<HouseModel>?, HouseError?>> fetchHouses();
  Future<Either<String?, HouseError?>> addHouse(
      String title,
      String location,
      String description,
      num price,
      String category,
      num bedrooms,
      num bathrooms,
      num floors,
      bool forRent,
      File mainIMage,
      List<File> subImages);
}
