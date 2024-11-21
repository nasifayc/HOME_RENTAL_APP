import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_app/core/theme/app_theme.dart';
import 'package:home_app/cubits/auth.dart';
import 'package:home_app/screen/layout/sign_up_page.dart';
import 'package:home_app/screen/onboarding.dart';
import 'package:home_app/widget/login/login_form.dart';

class LeftNavBar extends StatelessWidget {
  const LeftNavBar({super.key});

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
              Icons.category,
              color: theme.primaryText,
            ),
            title: Text(
              'Categories',
              style: theme.typography.bodySmall,
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.favorite,
              color: theme.primaryText,
            ),
            title: Text(
              'Wishlist',
              style: theme.typography.bodySmall,
            ),
            onTap: () {},
          ),
          // ListTile(
          //   leading: Icon(
          //     Icons.library_books,
          //     color: theme.primaryText,
          //   ),
          //   title: Text(
          //     'My Library',
          //     style: theme.typography.bodySmall,
          //   ),
          //   onTap: () {
          //
          //   },
          // ),
          ListTile(
            leading: Icon(
              Icons.download,
              color: theme.primaryText,
            ),
            title: Text(
              'Downloads',
              style: theme.typography.bodySmall,
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: theme.primaryText,
            ),
            title: Text(
              'Account',
              style: theme.typography.bodySmall,
            ),
            onTap: () {},
          ),
          // ListTile(
          //   leading: Icon(
          //     Icons.history,
          //     color: theme.primaryText,
          //   ),
          //   title: Text(
          //     'Orders',
          //     style: theme.typography.bodySmall,
          //   ),
          //   onTap: () {
          //
          //   },
          // ),
          ListTile(
            leading: Icon(
              Icons.wb_sunny,
              color: theme.primaryText,
            ),
            title: Text(
              'Light theme',
              style: theme.typography.bodySmall,
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
              Icons.info,
              color: theme.primaryText,
            ),
            title: Text(
              'About Us',
              style: theme.typography.bodySmall,
            ),
            onTap: () {},
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
        ],
      ),
    );
  }
}
