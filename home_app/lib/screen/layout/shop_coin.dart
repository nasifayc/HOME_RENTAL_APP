import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:home_app/core/theme/app_theme.dart';
import 'package:home_app/cubits/chat.dart';
import 'package:home_app/cubits/house.dart';
import 'package:home_app/cubits/user.dart';
import 'package:home_app/screen/main_screens/web_view_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:home_app/core/api_url.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopCoin extends StatelessWidget {
  const ShopCoin({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> coinPackages = [
      {'coins': 1, 'price': 1},
      {'coins': 10, 'price': 7},
      {'coins': 50, 'price': 30},
      {'coins': 100, 'price': 70},
      {'coins': 500, 'price': 300},
      {'coins': 1000, 'price': 800},
      {'coins': 10000, 'price': 5000},
    ];

    AppTheme theme = AppTheme.of(context);

    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<UserCubit>(context).getProfile();
        BlocProvider.of<ChatCubit>(context).fetchChats();
        BlocProvider.of<HouseCubit>(context).fetchHouses();

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Coin Shop'),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: coinPackages.length,
          itemBuilder: (context, index) {
            final package = coinPackages[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 4,
              child: ListTile(
                leading: SizedBox(
                  width: 40,
                  child: Stack(
                    children: List.generate(
                      (package['coins'] / 50).clamp(1, 6).toInt(),
                      (i) => Positioned(
                        bottom: i * 2,
                        left: i * 1.03,
                        child: const Icon(
                          Icons.monetization_on_outlined,
                          color: Colors.amber,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                title: Text(
                  '${package['coins']} Coins',
                  style: theme.typography.titleMedium,
                ),
                subtitle: Text('${package['price']} ETB',
                    style: theme.typography.bodyMedium),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WebViewContainer()));
                    // try {
                    //   final prefs = await SharedPreferences.getInstance();
                    //   final refreshToken =
                    //       prefs.getString("refreshToken") ?? '';
                    //   String accessToken = prefs.getString("accessToken") ?? '';
                    //   var response = await http.post(
                    //     Uri.parse("$baserURL/api/v1/coins"),
                    //     body: jsonEncode({"coins": package['coins']}),
                    //     headers: {
                    //       "Authorization": "Bearer $accessToken",
                    //       "Content-Type": "application/json"
                    //     },
                    //   );

                    //   if (response.statusCode == 401 ||
                    //       response.statusCode == 403) {
                    //     final refreshResponse = await http.post(
                    //       Uri.parse("$baserURL/auth/refresh-token"),
                    //       body: jsonEncode({"token": refreshToken}),
                    //       headers: {"Content-Type": "application/json"},
                    //     );

                    //     if (refreshResponse.statusCode == 201) {
                    //       final data = jsonDecode(refreshResponse.body);
                    //       final prefs = await SharedPreferences.getInstance();
                    //       await prefs.setString(
                    //           "accessToken", data["access_token"]);
                    //       await prefs.setString(
                    //           "refreshToken", data["refresh_token"]);
                    //       accessToken = prefs.getString("accessToken") ?? '';

                    //       // Retry fetching chats with new token
                    //       response = await http.post(
                    //         Uri.parse("$baserURL/api/v1/coins"),
                    //         body: jsonEncode({"coins": package['coins']}),
                    //         headers: {
                    //           "Authorization": "Bearer $accessToken",
                    //           "Content-Type": "application/json"
                    //         },
                    //       );
                    //     } else {
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         const SnackBar(
                    //           content: Text('Unauthorized'),
                    //           backgroundColor: Colors.red,
                    //         ),
                    //       );
                    //     }
                    //   }

                    //   if (response.statusCode == 200) {
                    //     final url = jsonDecode(response.body);
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) =>
                    //                 WebViewContainer(url: url)));
                    //   }

                    //   print(response.statusCode);
                    // } catch (e) {
                    //   print(e);
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text('Network Error'),
                    //       backgroundColor: Colors.red,
                    //     ),
                    //   );
                    // }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Buy',
                    style: theme.typography.labelSmall,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
