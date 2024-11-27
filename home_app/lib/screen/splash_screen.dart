import 'package:flutter/material.dart';
import 'package:home_app/screen/layout/sign_up_page.dart';
import 'package:home_app/screen/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 5 seconds and navigate to the next screen
    Future.delayed(const Duration(seconds: 5), () async {
      bool visited = await _getSharedPref();
      if (!visited) {
        await _visit();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Onboarding()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  Future<bool> _getSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("hasVisited") ?? false;
  }

  Future<void> _visit() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("hasVisited", true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A90E2),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // House Logo
            Container(
              height: 100,
              width: 100,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.home,
                color: Color(0xFF4A90E2),
                size: 60,
              ),
            ),
            const SizedBox(height: 20),
            // App Slogan
            const Text(
              'Find, Rent, Relax',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Arial',
              ),
            ),
            const SizedBox(height: 30),
            // Loader
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
