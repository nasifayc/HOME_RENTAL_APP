import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_app/core/app_navigator.dart';
import 'package:home_app/core/bottom_nav_cubit/bottom_nav_cubit.dart';
import 'package:home_app/core/theme/app_theme.dart';
import 'package:home_app/cubits/auth.dart';
import 'package:home_app/cubits/house.dart';
import 'package:home_app/repositories/auth.dart';
import 'package:home_app/repositories/house.dart';
import 'package:home_app/screen/layout/login_page.dart';
import 'package:home_app/screen/layout/otp_screen.dart';
import 'package:home_app/screen/layout/sign_up_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = AuthRepository();
    final houseRepo = HouseRepository();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BottomNavCubit()),
        BlocProvider(create: (context) => AuthCubit(authRepo: authRepo)),
        BlocProvider(create: (context) => HouseCubit(houseRepo: houseRepo))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ebook store',
        theme: LightModeTheme().themeData,
        routes: {
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignUpPage(),
          '/otp': (context) => const OtpScreen(),
        },
        home: const AppNavigator(),
      ),
    );
  }
}
