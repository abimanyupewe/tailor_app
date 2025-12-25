import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_app/data/api_service.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/routes/app_routes.dart';
import 'package:tailor_app/controllers/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = Get.find<ApiService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final userData = controller.user.value;
        if (userData == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.orange),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value.isNotEmpty
                      ? controller.errorMessage.value
                      : 'Failed to load profile',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.getUserProfile,
                  child: const Text('Retry'),
                ),
                const SizedBox(height: 16),
                // Allow logout even if failed to load profile
                TextButton(
                  onPressed: () async {
                    await Get.find<ApiService>().logout();
                    Get.offAllNamed(AppRoutes.login);
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          );
        }

        // Data structure: {user: {username: ..., role: ...}, ...}
        final userObj = userData['user'] ?? {};
        final username = userObj['username'] ?? 'User';
        final email = userObj['email'];
        final avatarUrl = userObj['avatar'];
        final role = userObj['role'] ?? 'Unknown';

        // Extract Name and Address
        final firstName = userObj['first_name'];
        final lastName = userObj['last_name'];
        String fullName = username;
        if (firstName != null && firstName.toString().isNotEmpty) {
          fullName = '$firstName ${lastName ?? ''}'.trim();
        }
        final address = userData['address'];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade300,
                backgroundImage:
                    (avatarUrl != null && avatarUrl.toString().isNotEmpty)
                    ? NetworkImage(
                        avatarUrl.toString().startsWith('http')
                            ? avatarUrl
                            : '${apiService.baseUrl}$avatarUrl',
                      )
                    : null,
                child: (avatarUrl == null || avatarUrl.toString().isEmpty)
                    ? const Icon(Icons.person, size: 60, color: Colors.white)
                    : null,
              ),
              const SizedBox(height: 24),
              // Full Name
              Text(
                fullName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Username (if different from full name, optional, but we show username as subtitle or just email)
              if (fullName != username)
                Text(
                  '@$username',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              const SizedBox(height: 8),

              if (email != null && email.toString().isNotEmpty)
                Text(
                  email,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              const SizedBox(height: 8),

              // Phone Number
              if (userData['phone_number'] != null &&
                  userData['phone_number'].toString().isNotEmpty)
                Text(
                  userData['phone_number'],
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              const SizedBox(height: 16),

              // Address
              if (address != null && address.toString().isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        address,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Role: $role',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await apiService.logout();
                    Get.offAllNamed(AppRoutes.login);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
