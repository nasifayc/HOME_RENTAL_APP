import 'package:dartz/dartz.dart';
import 'package:home_app/model/token_model.dart';
import 'package:home_app/states/auth_state.dart';

abstract class IAuthRepository {
  Future<Either<AuthError?, AuthToken?>> signUp(
      String name, String phoneNumber, String password, String role);
  Future<Either<AuthError?, AuthToken?>> login(
      String phoneNumber, String password);
  Future<Either<AuthError?, String?>> changePassword(
      String oldPassword, String newPassword);
}
