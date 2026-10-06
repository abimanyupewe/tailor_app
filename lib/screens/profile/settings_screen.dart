import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_app/core/constants/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader("General"),
          _buildSettingTile(
            Iconsax.notification,
            "Notifications",
            hasSwitch: true,
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _buildSettingTile(
            Iconsax.global,
            "Language",
            subtitle: "English",
            onTap: () {},
          ),

          const SizedBox(height: 32),

          _buildSectionHeader("Support"),
          _buildSettingTile(
            Iconsax.shield_tick,
            "Privacy Policy",
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _buildSettingTile(
            Iconsax.document_text,
            "Terms of Service",
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _buildSettingTile(
            Iconsax.info_circle,
            "About App",
            subtitle: "Version 1.0.0",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey.shade500,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    IconData icon,
    String title, {
    String? subtitle,
    VoidCallback? onTap,
    bool hasSwitch = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.secondary.withOpacity(0.12)),
      ),
      child: ListTile(
        onTap: hasSwitch ? null : onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.primary,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              )
            : null,
        trailing: hasSwitch
            ? Switch(
                value: true,
                onChanged: (val) {},
                activeColor: AppColors.primary,
              )
            : null, // No Arrow as per strict request
      ),
    );
  }
}
