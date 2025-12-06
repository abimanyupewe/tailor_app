import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_app/presentation/bindings/initial_binding.dart';
import 'package:tailor_app/presentation/routes/app_routes.dart';

import 'package:tailor_app/presentation/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // final NavController navController = Get.find();

  // final List<Widget> pages = const [
  //   HomePage(),
  //   OrderPage(),
  //   FavoritePage(),
  //   ProfilePage(),
  // ];

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tailor App',
      theme: AppTheme.light,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.initial,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      // home: const MainWrapper(),
    );
  }
}
