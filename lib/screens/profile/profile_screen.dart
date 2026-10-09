import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_app/data/api_service.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/routes/app_routes.dart';
import 'package:tailor_app/controllers/profile_controller.dart';
import 'package:tailor_app/controllers/locale_controller.dart';
import 'package:tailor_app/screens/profile/edit_profile_screen.dart';
import 'package:tailor_app/screens/profile/personal_info_screen.dart';
import 'package:tailor_app/screens/profile/settings_screen.dart';
import 'package:tailor_app/widgets/skeleton.dart';
import 'package:tailor_app/l10n/generated/app_localizations.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = Get.find<ApiService>();

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).account,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Builder(
        builder: (context) => Obx(() {
        final l10n = AppLocalizations.of(context);
        // Resubscribe so this Obx rebuilds (fresh strings) on language switch.
        Get.find<LocaleController>().locale.value;
        if (controller.isLoading.value) {
          return const ProfileLoadingSkeleton();
        }

        final userData = controller.user.value;
        if (userData == null) {
          return Center(
              child: Text(l10n.errorLoadingProfile,
                  style: const TextStyle(color: Colors.white)));
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
            const SizedBox(height: 12),
            // HEADER SECTION (on primary)
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 44,
                          backgroundColor: Colors.white.withValues(alpha: 0.15),
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
                                  ? const Icon(Icons.person,
                                      size: 40, color: Colors.white70)
                                  : null,
                        ),
                      ),
                      // Edit badge
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => Get.to(() => const EditProfileScreen()),
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Iconsax.camera,
                                color: AppColors.primary, size: 14),
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
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // WHITE CONTENT SHEET
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMenuGroup([
                        _MenuEntry(
                          icon: Iconsax.user,
                          title: l10n.personalInfo,
                          onTap: () => Get.to(() => const PersonalInfoScreen()),
                        ),
                        _MenuEntry(
                          icon: Iconsax.setting_2,
                          title: l10n.settings,
                          onTap: () => Get.to(() => const SettingsScreen()),
                        ),
                      ]),
                      const SizedBox(height: 16),
                      _buildMenuGroup([
                        _MenuEntry(
                          icon: Iconsax.logout,
                          title: l10n.logout,
                          isDestructive: true,
                          onTap: () async {
                            await apiService.logout();
                            Get.offAllNamed(AppRoutes.login);
                          },
                        ),
                      ]),
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          l10n.versionLabel('1.0.0'),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
        }),
      ),
    );
  }



  Widget _buildMenuGroup(List<_MenuEntry> entries) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < entries.length; i++) ...[
            _buildMenuRow(entries[i]),
            if (i < entries.length - 1)
              Divider(
                height: 1,
                indent: 60,
                endIndent: 16,
                color: AppColors.secondary.withValues(alpha: 0.1),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuRow(_MenuEntry entry) {
    final color = entry.isDestructive ? Colors.red : AppColors.primary;
    return InkWell(
      onTap: entry.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: entry.isDestructive
                    ? Colors.red.withValues(alpha: 0.08)
                    : AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(entry.icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                entry.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: color,
                ),
              ),
            ),
            if (!entry.isDestructive)
              Icon(
                Iconsax.arrow_right_3,
                size: 16,
                color: Colors.grey.shade400,
              ),
          ],
        ),
      ),
    );
  }
}

class _MenuEntry {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool isDestructive;

  const _MenuEntry({
    required this.icon,
    required this.title,
    this.onTap,
    this.isDestructive = false,
  });
}
