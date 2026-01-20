import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/controllers/profile_controller.dart';
import 'package:tailor_app/screens/profile/edit_profile_screen.dart';

class PersonalInfoScreen extends GetView<ProfileController> {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Informasi Pribadi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final userData = controller.user.value;
        if (userData == null) return const SizedBox();

        final userObj = userData['user'] ?? {};
        final email = userObj['email'];
        final username = userObj['username'];

        // Full Name Logic
        final firstName = userObj['first_name']?.toString() ?? '';
        final lastName = userObj['last_name']?.toString() ?? '';
        String fullName = '$firstName $lastName'.trim();

        if (fullName.isEmpty) {
          fullName = '-';
        }

        // Robust extraction for Address and Phone
        final address = userData['address'] ?? userObj['address'];
        final phoneNumber = userData['phone_number'] ?? userObj['phone_number'];

        return RefreshIndicator(
          onRefresh: () async {
            await controller.getUserProfile();
          },
          color: Colors.white,
          backgroundColor: AppColors.primary,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            children: [
              _buildInfoTile(Iconsax.user, "Username", username ?? "-"),
              const Divider(height: 30),
              _buildInfoTile(Iconsax.profile_circle, "Full Name", fullName),
              const Divider(height: 30),
              _buildInfoTile(Iconsax.sms, "Email", email ?? "-"),
              const Divider(height: 30),
              _buildInfoTile(Iconsax.call, "Phone Number", phoneNumber ?? "-"),
              const Divider(height: 30),
              _buildInfoTile(Iconsax.location, "Address", address ?? "-"),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const EditProfileScreen()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Edit Profile",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 24, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
