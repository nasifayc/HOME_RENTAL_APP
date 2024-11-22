import 'package:dartz/dartz.dart';
import 'package:home_app/model/user_model.dart';
import 'package:home_app/states/user_state.dart';

abstract class IUserRepository {
  Future<Either<UserError?, User?>> fetchProfile();
}