import 'package:flutter/material.dart';
import 'package:iti_final_project/consts/app_colors.dart';
import 'package:iti_final_project/pages/auth/login_page.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.appLightBlue,
              AppColors.appBlue,
            ],
          ),
        ),
        child: Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: Colors.grey[300]!,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome to",
                  style: TextStyle(
                      fontSize: 20,
                      color: AppColors.appWhite,
                      fontFamily: 'Poppins'
                  ),
                ),
                Text(
                  "Shafey Store",
                  style: TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appWhite,
                      fontFamily: 'Poppins'
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Don\'t worry about\nThe Shopping we\'re all here',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }
}