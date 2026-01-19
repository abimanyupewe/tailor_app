import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/controllers/navigation_controller.dart';
import 'package:tailor_app/controllers/chat_controller.dart';
import 'package:tailor_app/screens/home/home_screen.dart';
import 'package:tailor_app/screens/map/map_screen.dart';
import 'package:tailor_app/screens/chat/chat_list_screen.dart';
import 'package:tailor_app/screens/order/order_list_screen.dart';
import 'package:tailor_app/screens/profile/profile_screen.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    Get.put(ChatController());

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: const [
            HomeScreen(),
            MapScreen(),
            OrderListScreen(),
            ChatListScreen(),
            ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          backgroundColor: Colors.white,
          indicatorColor: AppColors.primary.withOpacity(0.1),
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.changeIndex(index),
          destinations: [
            NavigationDestination(
              icon: Icon(Iconsax.home),
              selectedIcon: Icon(Iconsax.home, color: AppColors.primary),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.map),
              selectedIcon: Icon(Iconsax.map, color: AppColors.primary),
              label: 'Map',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.bag),
              selectedIcon: Icon(Iconsax.bag, color: AppColors.primary),
              label: 'Orders',
            ),
            NavigationDestination(
              icon: Obx(() {
                // Get unread count safely
                int count = 0;
                try {
                  count = Get.find<ChatController>().totalUnreadCount;
                } catch (_) {}

                return count > 0
                    ? Badge(
                        label: Text(count.toString()),
                        child: const Icon(Iconsax.message),
                      )
                    : const Icon(Iconsax.message);
              }),
              selectedIcon: const Icon(
                Iconsax.message,
                color: AppColors.primary,
              ),
              label: 'Chat',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.user),
              selectedIcon: Icon(Iconsax.user, color: AppColors.primary),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
