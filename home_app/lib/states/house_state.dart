import 'package:home_app/model/house_model.dart';

abstract class HouseState {}

class HouseInitial extends HouseState {}

class HouseLoading extends HouseState {}

class HouseLoaded extends HouseState {
  final List<HouseModel> houses;

  HouseLoaded(this.houses);
}

class HouseError extends HouseState {
  final String message;

  HouseError(this.message);
}
