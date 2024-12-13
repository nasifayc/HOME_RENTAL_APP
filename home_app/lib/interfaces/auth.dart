import 'package:dartz/dartz.dart';
import 'package:home_app/model/token_model.dart';
import 'package:home_app/states/auth_state.dart';
import 'package:home_app/states/user_state.dart';

abstract class IAuthRepository {
  Future<Either<AuthError?, AuthToken?>> signUp(
      String name, String phoneNumber, String password);
  Future<Either<AuthError?, AuthToken?>> login(
      String phoneNumber, String password);
  Future<Either<AuthError?, String?>> changePassword(
      String oldPassword, String newPassword);
  Future<Either<AuthError?, AuthToken?>> checkToken();
  Future<Either<UserError?, String?>> changeStatus();
}
