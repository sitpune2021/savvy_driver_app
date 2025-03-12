import 'dart:async';

import 'package:flutter/material.dart';
import 'package:savvy_aqua_delivery/screens/dashboard_screen/dashboard_screen.dart';
import 'package:savvy_aqua_delivery/screens/login_screen/login_screen.dart';
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

    login();
  }

  void login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool? isLoggedIn = prefs.getBool("isLoggedIn");
    print("---------------------isLoggedIn$isLoggedIn");

    if (isLoggedIn == true) {
      Timer(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DashboardScreen(),
            ));
      });
    } else {
      Timer(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              color: Colors.white,
              child: const Text("splash"),
            ),
          ),
        ],
      ),
    );
  }
}
