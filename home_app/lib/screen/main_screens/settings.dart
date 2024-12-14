import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_app/core/theme/app_theme.dart';
import 'package:home_app/cubits/auth.dart';
import 'package:home_app/cubits/user.dart';
import 'package:home_app/model/user_model.dart';
import 'package:home_app/states/auth_state.dart';
import 'dart:convert';

import 'package:home_app/core/api_url.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final User user;
  const SettingsPage({required this.user, super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool isCurrentPasswordVisible = false;
  bool isNewPasswordVisible = false;
  String role = 'Seller';
  UserCubit? userCubit;

  @override
  void initState() {
    role = widget.user.role;
    userCubit = BlocProvider.of<UserCubit>(context);

    super.initState();
  }

  Future changeStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString("refreshToken") ?? '';
    var accessToken = prefs.getString("accessToken") ?? '';

    try {
      var response = await http.patch(
        Uri.parse('$baserURL/api/v1/auth/change-status'),
        headers: {
          "Authorization": "Bearer $accessToken",
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

          response = await http.patch(
            Uri.parse('$baserURL/api/v1/auth/change-status'),
            headers: {
              "Authorization": "Bearer $accessToken",
            },
          );
        } else {
          return {"error": 'cant refresh token'};
        }
      }

      print(response.statusCode);

      if (response.statusCode == 200) {
        userCubit?.getProfile();
        return {"error": ""};
      } else {
        return {"error": "error updating user status"};
      }
    } catch (e) {
      return {"error": "network error"};
    }
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    AppTheme theme = AppTheme.of(context);

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ChangeSuccessState) {
          currentPasswordController.clear();
          newPasswordController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Password Changed successfully!"),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 1,
            title: Text(
              "Settings",
              style: theme.typography.titleMedium,
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text('User Information', style: theme.typography.bodyMedium),
                const SizedBox(height: 8.0),
                // Name (Unchangeable)
                ListTile(
                  leading: Icon(Icons.person, color: theme.tertiary),
                  title: Text(
                    'Name',
                    style: theme.typography.titleSmall,
                  ),
                  subtitle:
                      Text(widget.user.name, style: theme.typography.bodySmall),
                ),
                const Divider(),
                // Phone Number (Unchangeable)
                ListTile(
                  leading: Icon(Icons.phone, color: theme.tertiary),
                  title: Text(
                    'Phone Number',
                    style: theme.typography.titleSmall,
                  ),
                  subtitle: Text(
                    widget.user.phoneNumber,
                    style: theme.typography.bodySmall,
                  ),
                ),
                const Divider(),
                // Password Update Section
                const SizedBox(height: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Switch Profile',
                      style: theme.typography.bodyMedium,
                    ),
                    const SizedBox(height: 20.0),

                    // Seller Profile
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      elevation: 3.0,
                      child: ListTile(
                        leading: const Icon(Icons.storefront,
                            color: Colors.blueAccent, size: 30.0),
                        title: Text(
                          "Seller",
                          style: theme.typography.bodySmall,
                        ),
                        trailing: Checkbox(
                          value: role == "Seller",
                          onChanged: (val) async {
                            final result = await changeStatus();

                            if (result['error'] == '') {
                              setState(() {
                                role = "Seller";
                              });
                            } else {
                              print('Error: ${result["error"]}');
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          activeColor: Colors.blueAccent,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16.0),

                    // Buyer Profile
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      elevation: 3.0,
                      child: ListTile(
                        leading: const Icon(Icons.shopping_cart,
                            color: Colors.green, size: 30.0),
                        title: Text(
                          "Buyer",
                          style: theme.typography.bodySmall,
                        ),
                        trailing: Checkbox(
                          value: role == "Buyer",
                          onChanged: (val) async {
                            final result = await changeStatus();

                            if (result['error'] == '') {
                              setState(() {
                                role =
                                    "Buyer"; // Update the checkbox state if successful
                              });
                            } else {
                              // Optionally show an error message (e.g., using a SnackBar)
                              print('Error: ${result["error"]}');
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          activeColor: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Update Password',
                  style: theme.typography.bodyMedium,
                ),
                const SizedBox(height: 16.0),
                // Current Password
                TextField(
                  controller: currentPasswordController,
                  obscureText: !isCurrentPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    labelStyle: theme.typography.titleSmall,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        color: const Color(0xFF4A90E2),
                        isCurrentPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isCurrentPasswordVisible = !isCurrentPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                state is AuthError && state.password != ''
                    ? Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 6,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  state.password,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 204, 43, 31)),
                                )),
                          ],
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(height: 16.0),
                // New Password
                TextField(
                  controller: newPasswordController,
                  obscureText: !isNewPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    labelStyle: theme.typography.titleSmall,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        color: const Color(0xFF4A90E2),
                        isNewPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isNewPasswordVisible = !isNewPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                state is AuthError && state.phoneNumber != ''
                    ? Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 6,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  state.phoneNumber,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 204, 43, 31)),
                                )),
                          ],
                        ),
                      )
                    : const SizedBox(),
                state is AuthError && state.server != ''
                    ? Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 6,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  state.server,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 204, 43, 31)),
                                )),
                          ],
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(height: 24.0),
                // Save Button
                Center(
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        authCubit.changePassword(
                          currentPasswordController.text,
                          newPasswordController.text,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32.0,
                          vertical: 12.0,
                        ),
                      ),
                      child: state is AuthLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Update Password',
                              style: theme.typography.labelSmall,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
