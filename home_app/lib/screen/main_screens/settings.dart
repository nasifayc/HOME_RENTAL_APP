import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_app/cubits/auth.dart';
import 'package:home_app/model/user_model.dart';
import 'package:home_app/states/auth_state.dart';

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

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);

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
            title: const Text(
              "Settings",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'User Information',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8.0),
                // Name (Unchangeable)
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.grey),
                  title: const Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    widget.user.name,
                    style: const TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                ),
                const Divider(),
                // Phone Number (Unchangeable)
                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.grey),
                  title: const Text(
                    'Phone Number',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    widget.user.phoneNumber,
                    style: const TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                ),
                const Divider(),
                // Password Update Section
                const SizedBox(height: 16.0),
                const Text(
                  'Update Password',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16.0),
                // Current Password
                TextField(
                  controller: currentPasswordController,
                  obscureText: !isCurrentPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    labelStyle: const TextStyle(fontSize: 16),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock, color: Colors.black),
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
                    labelStyle: const TextStyle(fontSize: 16),
                    border: const OutlineInputBorder(),
                    prefixIcon:
                        const Icon(Icons.lock_outline, color: Colors.black),
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
                        backgroundColor: Colors.black,
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
                          : const Text(
                              'Update Password',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
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
