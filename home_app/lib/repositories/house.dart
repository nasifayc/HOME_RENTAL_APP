import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:home_app/interfaces/house.dart';
import 'package:home_app/model/house_model.dart';
import 'package:home_app/states/house_state.dart';
import 'package:home_app/utils/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HouseRepository implements IHouseRepository {
  @override
  Future<Either<List<HouseModel>?, HouseError?>> fetchHouses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final _ = prefs.getString("refreshToken") ?? '';
      final accessToken = prefs.getString("accessToken") ?? '';
      final response = await http.get(
        Uri.parse("$baserURL/houses"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json"
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        List<dynamic> houseJson = jsonDecode(response.body);
        return Left(
            houseJson.map((json) => HouseModel.fromJson(json)).toList());
      } else {
        return Right(HouseError('failed to fetch products'));
      }
    } catch (e) {
      print(e);
      return Right(HouseError('failed to fetch products'));
    }
  }
}
