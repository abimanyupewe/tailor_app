import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_app/core/constants/app_colors.dart';

class AppToast {
  const AppToast._();

  static void success(String message, {String title = 'Success'}) => _show(
        title,
        message,
        AppColors.secondary,
        Icons.check_circle_outline,
      );

  static void error(String message, {String title = 'Error'}) => _show(
        title,
        message,
        Colors.red.shade700,
        Icons.error_outline,
      );

  static void info(String message, {String title = 'Info'}) => _show(
        title,
        message,
        AppColors.primary,
        Icons.info_outline,
      );

  static void warning(String message, {String title = 'Warning'}) => _show(
        title,
        message,
        Colors.orange.shade700,
        Icons.warning_amber_outlined,
      );

  static void action(
    String title,
    String message, {
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    _show(
      title,
      message,
      Colors.orange.shade700,
      Icons.warning_amber_outlined,
      mainButton: TextButton(
        onPressed: onAction,
        child: Text(
          actionLabel,
          style: TextStyle(color: Colors.orange.shade700),
        ),
      ),
    );
  }

  static void _show(
    String title,
    String message,
    Color color,
    IconData icon, {
    TextButton? mainButton,
  }) {
    Get.rawSnackbar(
      title: title,
      message: message,
      icon: Icon(icon, color: color),
      mainButton: mainButton,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      borderColor: color.withValues(alpha: 0.25),
      borderWidth: 1,
      borderRadius: 12,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      boxShadows: const [],
      titleText: Text(
        title,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
      ),
      messageText: Text(
        message,
        style: TextStyle(fontSize: 12, color: AppColors.secondary),
      ),
      duration: const Duration(seconds: 3),
    );
  }
}
