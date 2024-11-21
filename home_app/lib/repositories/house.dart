import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:home_app/interfaces/house.dart';
import 'package:home_app/model/house_model.dart';
import 'package:home_app/states/house_state.dart';
import 'package:home_app/utils/api_url.dart';
import 'package:image_picker/image_picker.dart';
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

  @override
  Future<Either<List<HouseModel>?, HouseError?>> addHouse(
      String title,
      String location,
      String description,
      num price,
      String category,
      num bedrooms,
      num bathrooms,
      num floors,
      bool forRent,
      XFile mainImage,
      List<XFile> subImages) async {
    final Dio _dio = Dio();

    FormData formData = FormData.fromMap({
      "title": title,
      "location": location,
      "description": description,
      "price": price,
      "category": category,
      "number_of_bedrooms": bedrooms,
      "number_of_bathrooms": bathrooms,
      "number_of_floors": floors,
      "for_Rent": forRent ? "true" : "false",
      "main_image": await MultipartFile.fromFile(mainImage.path,
          filename: mainImage.path.split('/').last),
      "sub_images": await Future.wait(subImages.map((image) async {
        return MultipartFile.fromFile(image.path,
            filename: image.path.split('/').last);
      })),
    });

    final prefs = await SharedPreferences.getInstance();
    final _ = prefs.getString("refreshToken") ?? '';
    final accessToken = prefs.getString("accessToken") ?? '';

    Response response = await _dio.post(
      "$baserURL/houses",
      data: formData,
      options: Options(headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "multipart/form-data",
      }),
    );

    print(response.data);

    return Right(HouseError(''));
  }
}
