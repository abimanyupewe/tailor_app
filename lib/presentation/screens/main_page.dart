import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_app/presentation/controllers/nav_controller.dart';
import 'package:tailor_app/presentation/screens/home/home_screen.dart';
import 'package:tailor_app/presentation/widgets/bottom_nav.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final List<Widget> pages = const [
    HomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final NavController navController = Get.find();

    return Obx(
      () => Scaffold(
        body: pages[navController.currentIndex.value],
        bottomNavigationBar: BottomNavbar(),
      ),
    );
  }
}
