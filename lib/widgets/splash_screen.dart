import 'package:flutter/material.dart';
import 'package:tailor_app/core/constants/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Image.asset(
          'assets/images/logo/logo.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
