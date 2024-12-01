import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_app/interfaces/user.dart';
import 'package:home_app/states/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final IUserRepository userRepo;
  UserCubit({required this.userRepo}) : super(UserInitial());
  void getProfile() async {
    final response = await userRepo.fetchProfile();
    response.fold((error) {
      emit(UserError(error!.message));
    }, (user) {
      emit(UserLoaded(user!));
    });
  }

  void fetchRate(String id) async {
    final response = await userRepo.fetchRate(id);
    response.fold((error) {
      emit(UserError(error!.message));
    }, (rate) {
      emit(rate!);
    });
  }

  void rate(num amount, String id) async {
    final response = await userRepo.rateUser(amount, id);
    response.fold((error) {
      emit(UserError(error!.message));
    }, (user) {
      fetchRate(id);
    });
  }
}
