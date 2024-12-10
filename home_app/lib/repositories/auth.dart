import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:home_app/interfaces/auth.dart';
import 'package:home_app/model/token_model.dart';
import 'package:home_app/states/auth_state.dart';
import 'package:home_app/core/api_url.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository implements IAuthRepository {
  @override
  Future<Either<AuthError?, AuthToken?>> signUp(
      String name, String phoneNumber, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baserURL/api/v1/auth/signup'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "role": role,
          "phoneNumber": phoneNumber,
          "password": password,
        }),
      );

      print(response.statusCode);

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("accessToken", data["access_token"]);
        await prefs.setString("refreshToken", data["refresh_token"]);
        AuthToken authToken = AuthToken.fromJson(data);
        return Right(authToken);
      } else if (response.statusCode == 409) {
        return Left(AuthError("phone number is already taken", "", "", "", ''));
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);

        final phoneNumberError = data["errors"]["phoneNumber"] ?? "";
        final passwordError = data["errors"]["password"] ?? "";
        final nameError = data["errors"]["name"] ?? "";
        final roleError = data["errors"]["role"] ?? "";

        return Left(AuthError(
            phoneNumberError.toString(),
            passwordError.toString(),
            nameError.toString(),
            "",
            roleError.toString()));
      } else {
        print(response.statusCode);
        return Left(AuthError("", "", "", "server error", ''));
      }
    } catch (e) {
      print(e);
      return Left(AuthError("", "", "", "Server Error", ''));
    }
  }

  @override
  Future<Either<AuthError?, AuthToken?>> login(
      String phoneNumber, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baserURL/api/v1/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "phoneNumber": phoneNumber,
          "password": password,
        }),
      );

      print('$baserURL/api/v1/auth/login');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("accessToken", data["access_token"]);
        await prefs.setString("refreshToken", data["refresh_token"]);
        AuthToken authToken = AuthToken.fromJson(data);
        return Right(authToken);
      } else if (response.statusCode == 401) {
        return Left(
            AuthError("", "Phone Number or Password is Incorrect", "", "", ''));
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);

        final phoneNumberError = data["errors"]["phoneNumber"] ?? "";
        final passwordError = data["errors"]["password"] ?? "";

        return Left(AuthError(
            phoneNumberError.toString(), passwordError.toString(), "", "", ''));
      } else {
        return Left(AuthError("", "", "", "server error", ''));
      }
    } catch (e) {
      print(e);
      return Left(AuthError("", "", "", "Server Error", ''));
    }
  }

  @override
  Future<Either<AuthError?, String?>> changePassword(
      String oldPassword, String newPassword) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString("refreshToken") ?? '';
      String accessToken = prefs.getString("accessToken") ?? '';
      var response = await http.patch(
        Uri.parse('$baserURL/api/v1/auth/change-password'),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "old_password": oldPassword,
          "new_password": newPassword,
        }),
      );

      if (response.statusCode == 401 || response.statusCode == 403) {
        final refreshResponse = await http.post(
          Uri.parse("$baserURL/api/v1/auth/refresh-token"),
          body: jsonEncode({"token": refreshToken}),
          headers: {"Content-Type": "application/json"},
        );

        if (refreshResponse.statusCode == 201) {
          final data = jsonDecode(refreshResponse.body);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("accessToken", data["access_token"]);
          await prefs.setString("refreshToken", data["refresh_token"]);
          accessToken = prefs.getString("accessToken") ?? '';

          response = await http.patch(
            Uri.parse('$baserURL/auth/change-password'),
            headers: {
              "Authorization": "Bearer $accessToken",
              "Content-Type": "application/json"
            },
            body: jsonEncode({
              "old_password": oldPassword,
              "new_password": newPassword,
            }),
          );
        } else {
          return Left(
              AuthError('Failed to refresh access token', '', '', '', ''));
        }
      }

      if (response.statusCode == 204) {
        return const Right('');
      } else if (response.statusCode == 422) {
        return Left(AuthError("", "old password is incorrect", "", "", ''));
      } else if (response.statusCode == 401) {
        return Left(AuthError("", "Unauthorized", "", "", ''));
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);

        final oldPasswordError = data["errors"]["old_password"] ?? "";
        final newPasswordError = data["errors"]["new_password"] ?? "";

        return Left(AuthError(newPasswordError.toString(),
            oldPasswordError.toString(), "", "", ''));
      } else {
        return Left(AuthError("", "", "", "server error", ''));
      }
    } catch (e) {
      print(e);
      return Left(AuthError("", "", "", "Server Error", ''));
    }
  }

  @override
  Future<Either<AuthError?, AuthToken?>> checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString("refreshToken") ?? '';
    final accessToken = prefs.getString("accessToken") ?? '';

    try {
      final response = await http.post(
        Uri.parse('$baserURL/api/v1/auth/verify-token'),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "token": refreshToken,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print(data);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('accessToken', data["access_token"]);

        AuthToken authToken = AuthToken.fromJson(data);
        return Right(authToken);
      } else {
        return Left(AuthError("", "", "", "", ""));
      }
    } catch (e) {
      print(e);
      return Left(AuthError("", "", "", "", ""));
    }
  }
}
