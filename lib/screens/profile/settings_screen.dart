import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_app/controllers/locale_controller.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/l10n/generated/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeController = Get.find<LocaleController>();
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          l10n.chooseLanguage,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        content: Obx(
          () => RadioGroup<String>(
            groupValue: localeController.locale.value.languageCode,
            onChanged: (value) {
              if (value == null) return;
              localeController.changeLocale(Locale(value));
              Get.back();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Radio<String>(value: 'en'),
                    Text(l10n.languageEnglish),
                  ],
                ),
                Row(
                  children: [
                    const Radio<String>(value: 'id'),
                    Text(l10n.languageIndonesian),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeController = Get.find<LocaleController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: const TextStyle(
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
          _buildSectionHeader(l10n.general),
          _buildSettingTile(
            Iconsax.notification,
            l10n.notifications,
            hasSwitch: true,
            onTap: () {},
          ),
          const SizedBox(height: 16),
          Obx(
            () => _buildSettingTile(
              Iconsax.global,
              l10n.language,
              subtitle: localeController.languageName,
              onTap: () => _showLanguageDialog(context),
            ),
          ),

          const SizedBox(height: 32),

          _buildSectionHeader(l10n.support),
          _buildSettingTile(
            Iconsax.shield_tick,
            l10n.privacyPolicy,
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _buildSettingTile(
            Iconsax.document_text,
            l10n.termsOfService,
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _buildSettingTile(
            Iconsax.info_circle,
            l10n.aboutApp,
            subtitle: l10n.versionLabel('1.0.0'),
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
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
            color: AppColors.secondary.withValues(alpha: 0.12)),
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
                activeThumbColor: AppColors.primary,
              )
            : null, // No Arrow as per strict request
      ),
    );
  }
}
