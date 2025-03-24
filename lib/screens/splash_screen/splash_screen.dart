import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
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
      backgroundColor: Colors.white,
      body: Center(
        child: AvatarGlow(
          glowColor: Colors.blue, // Adjust glow color
          endRadius: 100.0, // Glow radius
          duration: Duration(milliseconds: 1000), // Glow animation speed
          repeat: true, // Keeps pulsing
          showTwoGlows: true, // Double layer glow
          child: Material(
            elevation: 8.0,
            shape: CircleBorder(),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 75, // Adjust image size
              child: Image.asset(
                'assets/images/SavyLogo.png',
                width: 150,
                height: 150,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
