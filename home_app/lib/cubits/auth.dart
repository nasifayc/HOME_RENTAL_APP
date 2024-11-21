import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_app/interfaces/auth.dart';
import 'package:home_app/states/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IAuthRepository authRepo;
  AuthCubit({required this.authRepo}) : super(AuthInitial());

  Future<void> login(String phoneNumber, String password) async {
    emit(AuthLoading());

    try {
      final response = await authRepo.login(phoneNumber, password);
      response.fold((error) {
        emit(error!);
      }, (token) {
        emit(Authenticated(authToken: token!));
      });
    } catch (e) {
      emit(AuthError("", "", "", "An error occurred: $e", ''));
    }
  }

  Future<void> signup(
      String phoneNumber, String password, String name, String role) async {
    emit(AuthLoading());

    try {
      final response = await authRepo.signUp(name, phoneNumber, password, role);
      response.fold((error) {
        emit(error!);
      }, (token) {
        emit(Authenticated(authToken: token!));
      });
    } catch (e) {
      emit(AuthError("", "", "", "An error occurred: $e", ''));
    }
  }
}
