import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:home_app/interfaces/user.dart';
import 'package:home_app/model/user_model.dart';
import 'package:home_app/states/user_state.dart';
import 'package:home_app/utils/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserRepository implements IUserRepository {
  @override
  Future<Either<UserError?, User?>> fetchProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final _ = prefs.getString("refreshToken") ?? '';
      final accessToken = prefs.getString("accessToken") ?? '';
      final response = await http.get(
        Uri.parse("$baserURL/auth/profile"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        final userJson = jsonDecode(response.body);

        return Right(User.fromJson(userJson));
      } else {
        return Left(UserError('failed to load profile'));
      }
    } catch (e) {
      return Left(UserError('server error'));
    }
  }
}
