import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/nav_controller.dart';

class BottomNavbar extends StatelessWidget {
  BottomNavbar({super.key});

  final NavController navController = Get.find<NavController>();

  final List<Map<String, dynamic>> navItems = [
    {'icon': Icons.home_rounded, 'label': 'Home'},
    {'icon': Icons.shopping_bag_rounded, 'label': 'Orders'},
    {'icon': Icons.favorite_rounded, 'label': 'Favorite'},
    {'icon': Icons.person_rounded, 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: navController.currentIndex.value,
        onTap: navController.changePage,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.green,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: navItems.map((item) {
          int index = navItems.indexOf(item);
          bool isActive = navController.currentIndex.value == index;
          return BottomNavigationBarItem(
            icon: Icon(
              item['icon'],
              color: isActive ? Colors.green : Colors.green,
            ),
            label: item['label'],
          );
        }).toList(),
      ),
    );
  }
}
