import 'dart:convert';

import 'package:dartz/dartz.dart';
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
    try {
      var uri = Uri.parse("$baserURL/houses");

      // Create the multipart request
      var request = http.MultipartRequest('POST', uri);

      // Add the file to the request
      var file = await http.MultipartFile.fromPath(
        'main_image',
        mainImage.path,
      );

      // Add additional form fields
      request.fields['title'] = title;
      request.fields['location'] = location;
      request.fields["description"] = description;
      request.fields["price"] = price.toString();
      request.fields["category"] = category;
      request.fields["number_of_bedrooms"] = bedrooms.toString();
      request.fields["number_of_bathrooms"] = bathrooms.toString();
      request.fields["number_of_floors"] = floors.toString();
      request.fields["for_Rent"] = forRent ? "true" : "false";

      // Add the file to the request
      request.files.add(file);

      // Get access token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString("accessToken");

      // Ensure the access token is not null
      if (accessToken != null && accessToken.isNotEmpty) {
        // Add authorization header with the access token
        request.headers['Authorization'] = 'Bearer $accessToken';
      } else {
        print('Access token is missing or invalid.');
      }

      // Send the request
      var response = await request.send();

      // Handle response
      if (response.statusCode == 200) {
        print('Upload successful');
      } else {
        print('Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }

    return Right(HouseError(''));
  }
}
