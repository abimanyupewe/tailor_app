import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/presentation/controllers/navigation_controller.dart';
import 'package:tailor_app/presentation/screens/home/home_screen.dart';
import 'package:tailor_app/presentation/screens/map/map_screen.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: const [
            HomeScreen(),
            MapScreen(),
            Center(child: Text('Orders')), // Placeholder
            Center(child: Text('Profile')), // Placeholder
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          indicatorColor: AppColors.primary.withOpacity(0.2),
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.changeIndex(index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Iconsax.home),
              selectedIcon: Icon(Iconsax.home5, color: AppColors.primary),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.map),
              selectedIcon: Icon(Iconsax.map5, color: AppColors.primary),
              label: 'Map',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.bag),
              selectedIcon: Icon(Iconsax.bag5, color: Colors.green),
              label: 'Orders',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.user),
              selectedIcon: Icon(Iconsax.user5, color: Colors.green),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
