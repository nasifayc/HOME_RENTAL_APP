// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:home_app/cubits/auth.dart';
// import 'package:home_app/screen/layout/sign_up_page.dart';
// import 'package:home_app/screen/main_screens/landing_page.dart';
// import 'package:home_app/states/auth_state.dart';

// class AuthPage extends StatelessWidget {
//   const AuthPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
//       if (state is Authenticated) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           Navigator.pushReplacement(
//               context, MaterialPageRoute(builder: (context) => LandingPage()));
//         });
//       }
//       if (state is AuthLoading) {
//         return const Scaffold(
//           body: Center(
//             child: CircularProgressIndicator(),
//           ),
//         );
//       }
//       return const LoginPage();
//     });
//   }
// }
