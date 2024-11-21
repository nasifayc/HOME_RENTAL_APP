import 'package:dartz/dartz.dart';
import 'package:home_app/model/house_model.dart';
import 'package:home_app/states/house_state.dart';

abstract class IHouseRepository {
  Future<Either<List<HouseModel>?, HouseError?>> fetchHouses();
}
