import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_app/bindings/initial_binding.dart';
import 'package:tailor_app/routes/app_routes.dart';
import 'package:tailor_app/screens/onboarding/onboarding_screen.dart';

import 'package:tailor_app/theme/app_theme.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tailor App',
      theme: AppTheme.light,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.initial,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      // home: const OnboardingScreen(),
      // home: const MainWrapper(),
    );
  }
}
