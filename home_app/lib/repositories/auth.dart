import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:home_app/interfaces/auth.dart';
import 'package:home_app/model/token_model.dart';
import 'package:home_app/states/auth_state.dart';
import 'package:home_app/utils/api_url.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository implements IAuthRepository {
  @override
  Future<Either<AuthError?, AuthToken?>> signUp(
      String name, String phoneNumber, String password, String role) async {
    
    try {
      final response = await http.post(
        Uri.parse('$baserURL/auth/signup'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "role": role,
          "phoneNumber": phoneNumber,
          "password": password,
        }),
      );

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
        Uri.parse('$baserURL/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "phoneNumber": phoneNumber,
          "password": password,
        }),
      );

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
}