import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_app/controller/theme/theme_cubit.dart';
import 'package:home_app/core/theme/app_theme.dart';
import 'package:home_app/cubits/auth.dart';
import 'package:home_app/cubits/user.dart';
import 'package:home_app/screen/layout/sign_up_page.dart';
import 'package:home_app/screen/main_screens/settings.dart';
import 'package:home_app/states/user_state.dart';

class LeftNavBar extends StatefulWidget {
  const LeftNavBar({super.key});

  @override
  State<LeftNavBar> createState() => _LeftNavBarState();
}

class _LeftNavBarState extends State<LeftNavBar> {
  bool isLightTheme = true;
  String toTitleCase(String input) {
    if (input.isEmpty) return input;

    return input
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : word)
        .join(' ');
  }

  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    AppTheme theme = AppTheme.of(context);

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Drawer(
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              UserAccountsDrawerHeader(
                accountName: state is UserLoaded
                    ? Text(
                        toTitleCase(state.user.name),
                        style: theme.typography.bodyLargeWhite,
                      )
                    : const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                accountEmail: state is UserLoaded
                    ? Text(state.user.phoneNumber)
                    : const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: theme.primaryBackground,
                  child: ClipOval(
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[200],
                      child: Center(
                        child: state is UserLoaded
                            ? Text(
                                state.user.name[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : const CircularProgressIndicator(
                                color: Colors.black,
                              ),
                      ),
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: theme.primary,
                ),
              ),
              BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, state) {
                  return ListTile(
                    leading: Icon(
                      Icons.wb_sunny,
                      color: theme.primaryText,
                    ),
                    title: Text(
                      state == ThemeMode.dark ? 'Dark Mode' : 'Light Mode',
                      style: theme.typography.bodySmall,
                    ),
                    trailing: Switch(
                      thumbColor: WidgetStatePropertyAll(Colors.grey[200]),
                      trackColor: WidgetStatePropertyAll(Colors.grey[400]),
                      value: state == ThemeMode.dark,
                      onChanged: (bool value) {
                        final isDarkMode = state == ThemeMode.dark;
                        log(state.name);
                        context.read<ThemeCubit>().toggleTheme(!isDarkMode);
                      },
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: theme.primaryText,
                ),
                title: Text(
                  'Settings',
                  style: theme.typography.bodySmall,
                ),
                onTap: () {
                  state is UserLoaded
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SettingsPage(user: state.user),
                          ))
                      : null;
                  ;
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.help_outline,
                  color: theme.primaryText,
                ),
                title: Text(
                  'Help and Support',
                  style: theme.typography.bodySmall,
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/help");
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.info,
                  color: theme.primaryText,
                ),
                title: Text(
                  'About Us',
                  style: theme.typography.bodySmall,
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/about");
                },
              ),
              const Divider(),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: theme.primaryText,
                ),
                title: Text(
                  'Logout',
                  style: theme.typography.bodySmall,
                ),
                onTap: () {
                  showLogoutConfirmation(context, authCubit);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

Future<void> showLogoutConfirmation(
    BuildContext context, AuthCubit authCubit) async {
  final shouldLogout = await showDialog<bool>(
    context: context,
    barrierDismissible: false, // User must choose an option
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Logout Confirmation'),
        content: const Text('Are you sure you want to log out?'),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () {
              Navigator.of(context).pop(false); // User cancels logout
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black)
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.of(context).pop(true); // User confirms logout
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );

  if (shouldLogout == true) {
    authCubit.logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (route) => false,
    );
    ; // Proceed to logout if confirmed
  }
}
