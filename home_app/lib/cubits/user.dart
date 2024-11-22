import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_app/interfaces/user.dart';
import 'package:home_app/states/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final IUserRepository userRepo;
  UserCubit({required this.userRepo}) : super(UserInitial());
  void getProfile() async {
    emit(UserLoading());
    final response = await userRepo.fetchProfile();
    response.fold((error) {
      emit(UserError(error!.message));
    }, (user) {
      emit(UserLoaded(user!));
    });
  }
}
