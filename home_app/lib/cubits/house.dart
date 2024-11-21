import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_app/interfaces/house.dart';
import 'package:home_app/states/house_state.dart';

class HouseCubit extends Cubit<HouseState> {
  final IHouseRepository houseRepo;
  HouseCubit({required this.houseRepo}) : super(HouseInitial());
  Future<void> fetchHouses() async {
    emit(HouseLoading());
    final response = await houseRepo.fetchHouses();

    response.fold((houses) {
      emit(HouseLoaded(houses!));
    }, (error) {
      emit(error!);
    });
  }
}
