import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_app/data/api_service.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/routes/app_routes.dart';
import 'package:tailor_app/controllers/profile_controller.dart';
import 'package:tailor_app/screens/profile/edit_profile_screen.dart';
import 'package:tailor_app/screens/profile/personal_info_screen.dart';
import 'package:tailor_app/screens/profile/settings_screen.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = Get.find<ApiService>();

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text(
          'Account',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.white));
        }

        final userData = controller.user.value;
        if (userData == null) {
          return const Center(
              child: Text("Error loading profile",
                  style: TextStyle(color: Colors.white)));
        }

        final userObj = userData['user'] ?? {};
        final username = userObj['username'] ?? 'User';
        final email = userObj['email'];
        final avatarUrl = userObj['avatar'];
        final firstName = userObj['first_name'];
        final lastName = userObj['last_name'];
        String fullName = username;
        if (firstName != null && firstName.toString().isNotEmpty) {
          fullName = '$firstName ${lastName ?? ''}'.trim();
        }


        return Column(
          children: [
            const SizedBox(height: 20),
            // HEADER SECTION (On Primary Color)
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white.withOpacity(0.5), width: 1),
                        ),
                        child: CircleAvatar(
                          radius: 45, // Slightly smaller
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: (avatarUrl != null &&
                                  avatarUrl.toString().isNotEmpty)
                              ? NetworkImage(
                                  avatarUrl.toString().startsWith('http')
                                      ? avatarUrl
                                      : '${apiService.baseUrl}$avatarUrl',
                                )
                              : null,
                          child:
                              (avatarUrl == null || avatarUrl.toString().isEmpty)
                                  ? Icon(Icons.person,
                                      size: 40, color: Colors.grey.shade400)
                                  : null,
                        ),
                      ),
                      // Camera/Edit Icon
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => Get.to(() => const EditProfileScreen()),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color:
                                  Colors.white.withOpacity(0.2), // Glass effect
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: const Icon(Iconsax.camera,
                                color: Colors.white, size: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    fullName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (email != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        email,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // WHITE CONTENT SHEET
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMenuItem(
                        icon: Iconsax.user,
                        title: 'Informasi Pribadi',
                        onTap: () => Get.to(() => const PersonalInfoScreen()),
                      ),
                      
                      const SizedBox(height: 8),
                      _buildMenuItem(
                        icon: Iconsax.setting_2,
                        title: 'Settings',
                        onTap: () => Get.to(() => const SettingsScreen()),
                      ),
                      _buildMenuItem(
                        icon: Iconsax.logout,
                        title: 'Logout',
                        isDestructive: true,
                        onTap: () async {
                          await apiService.logout();
                          Get.offAllNamed(AppRoutes.login);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }



  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9), // Light grey bg for items
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), // Rounded icon bg
          ),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : Colors.black87,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isDestructive ? Colors.red : Colors.black87,
          ),
        ),
        minLeadingWidth: 0,
      ),
    );
  }
}
