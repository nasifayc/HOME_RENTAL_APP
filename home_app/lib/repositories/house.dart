import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:home_app/interfaces/house.dart';
import 'package:home_app/model/house_model.dart';
import 'package:home_app/states/house_state.dart';
import 'package:home_app/core/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HouseRepository implements IHouseRepository {
  @override
  Future<Either<List<HouseModel>?, HouseError?>> fetchHouses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString("refreshToken") ?? '';
      String accessToken = prefs.getString("accessToken") ?? '';
      var response = await http.get(
        Uri.parse("$baserURL/api/v1/houses"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json"
        },
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

          response = await http.get(
            Uri.parse("$baserURL/houses"),
            headers: {
              "Authorization": "Bearer $accessToken",
              "Content-Type": "application/json"
            },
          );
        } else {
          return Right(HouseError('Failed to refresh access token'));
        }
      }

      if (response.statusCode == 200) {
        List<dynamic> houseJson = jsonDecode(response.body);
        log(houseJson.toString());
        return Left(
            houseJson.map((json) => HouseModel.fromJson(json)).toList());
      } else {
        return Right(HouseError('failed to fetch products'));
      }
    } catch (e) {
      print(e);
      return Right(HouseError('Network Error'));
    }
  }

  @override
  Future<Either<String?, HouseError?>> addHouse(
    String title,
    String location,
    String description,
    num price,
    String category,
    num bedrooms,
    num bathrooms,
    num floors,
    bool forRent,
    File mainImage,
    List<File> subImages,
  ) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$baserURL/api/v1/houses'));
      request.files
          .add(await http.MultipartFile.fromPath('main_image', mainImage.path));
      final subImagePaths = subImages.map((image) => image.path);

      for (final path in subImagePaths) {
        request.files
            .add(await http.MultipartFile.fromPath('sub_images', path));
      }

      // Add additional form fields
      request.fields['title'] = title;
      request.fields['location'] = location;
      request.fields["description"] = description;
      request.fields["price"] = price.toString();
      request.fields["category"] = category;
      request.fields["number_of_bedrooms"] = bedrooms.toString();
      request.fields["number_of_bathrooms"] = bathrooms.toString();
      request.fields["number_of_floors"] = floors.toString();
      request.fields["for_rent"] = forRent ? "true" : "false";

      print(request.files);

      // Get access token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString("accessToken") ?? '';
      final refreshToken = prefs.getString("accessToken");

      request.headers['Authorization'] = 'Bearer $accessToken';

      // Send the request
      var response = await request.send();

      if (response.statusCode == 401 || response.statusCode == 403) {
        final refreshResponse = await http.post(
          Uri.parse("$baserURL/auth/refresh-token"),
          body: jsonEncode({"token": refreshToken}),
          headers: {"Content-Type": "application/json"},
        );
        for (final path in subImagePaths) {
          request.files
              .add(await http.MultipartFile.fromPath('sub_images', path));
        }

        if (refreshResponse.statusCode == 201) {
          final data = jsonDecode(refreshResponse.body);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("accessToken", data["access_token"]);
          await prefs.setString("refreshToken", data["refresh_token"]);
          accessToken = prefs.getString("accessToken") ?? '';

          request.headers['Authorization'] = 'Bearer $accessToken';

          response = await request.send();
        } else {
          return Right(HouseError('Failed to refresh access token'));
        }
      }

      print(response.statusCode);

      if (response.statusCode == 201) {
        return Left("Added Successfully");
      } else {
        print("failed");
        return Right(HouseError('upload failed'));
      }
    } catch (e) {
      print(e);
      return Right(HouseError('Network Error'));
    }
  }
}
