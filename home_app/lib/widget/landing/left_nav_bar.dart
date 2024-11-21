import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_app/core/theme/app_theme.dart';
import 'package:home_app/cubits/auth.dart';
import 'package:home_app/screen/layout/sign_up_page.dart';

class LeftNavBar extends StatefulWidget {
  const LeftNavBar({super.key});

  @override
  State<LeftNavBar> createState() => _LeftNavBarState();
}

class _LeftNavBarState extends State<LeftNavBar> {
  bool isLightTheme = true;

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    AppTheme theme = AppTheme.of(context);
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              "Nasifay Chala",
              style: theme.typography.bodyLargeWhite,
            ),
            accountEmail: const Text("nasifayc11@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: theme.primaryBackground,
              child: ClipOval(
                child: Image.asset('assets/images/customer-service.png'),
              ),
            ),
            decoration: BoxDecoration(
              color: theme.primary,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.wb_sunny,
              color: theme.primaryText,
            ),
            title: Text(
              'Light theme',
              style: theme.typography.bodySmall,
            ),
            trailing: Switch(
              thumbColor: WidgetStatePropertyAll(Colors.grey[200]),
              trackColor: WidgetStatePropertyAll(Colors.grey[400]),
              value: isLightTheme, // This should be a boolean state variable
              onChanged: (bool value) {
                setState(() {
                  isLightTheme = value;
                });
                // Add additional logic here if needed to change the theme
              },
            ),
            onTap: () {},
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
            onTap: () {},
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
              Icons.description_outlined,
              color: theme.primaryText,
            ),
            title: Text(
              'Terms and Conditions',
              style: theme.typography.bodySmall,
            ),
            onTap: () {},
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
              authCubit.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) =>
                        const LoginPage()), // Your main screen widget
                (route) => false,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: Text(
              'Delete Account',
              style: theme.typography.bodySmall,
            ),
          )
        ],
      ),
    );
  }
}
