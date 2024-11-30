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
      final refreshToken = prefs.getString("refreshToken") ?? '';
      String accessToken = prefs.getString("accessToken") ?? '';
      var response = await http.get(
        Uri.parse("$baserURL/api/v1/auth/profile"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 401 || response.statusCode == 403) {
        final refreshResponse = await http.post(
          Uri.parse("$baserURL/auth/refresh-token"),
          body: jsonEncode({"token": refreshToken}),
          headers: {"Content-Type": "application/json"},
        );

        if (refreshResponse.statusCode == 201) {
          final data = jsonDecode(refreshResponse.body);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("accessToken", data["access_token"]);
          await prefs.setString("refreshToken", data["refresh_token"]);
          accessToken = prefs.getString("accessToken") ?? '';

          response = await http.get(
            Uri.parse("$baserURL/auth/profile"),
            headers: {
              "Authorization": "Bearer $accessToken",
              "Content-Type": "application/json"
            },
          );
        } else {
          return Left(UserError('Failed to refresh access token'));
        }
      }

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
