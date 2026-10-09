import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/controllers/navigation_controller.dart';
import 'package:tailor_app/l10n/generated/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);

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
          indicatorColor: AppColors.primary.withValues(alpha: 0.1),
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.changeIndex(index),
          destinations: [
            NavigationDestination(
              icon: const Icon(Iconsax.home, color: Colors.grey),
              selectedIcon: Icon(Iconsax.home, color: AppColors.primary),
              label: l10n.navHome,
            ),
            NavigationDestination(
              icon: const Icon(Iconsax.map, color: Colors.grey),
              selectedIcon: Icon(Iconsax.map, color: AppColors.primary),
              label: l10n.navMap,
            ),
            NavigationDestination(
              icon: const Icon(Iconsax.bag, color: Colors.grey),
              selectedIcon: Icon(Iconsax.bag, color: AppColors.primary),
              label: l10n.navOrders,
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
              label: l10n.navChat,
            ),
            NavigationDestination(
              icon: const Icon(Iconsax.user, color: Colors.grey),
              selectedIcon: Icon(Iconsax.user, color: AppColors.primary),
              label: l10n.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}
