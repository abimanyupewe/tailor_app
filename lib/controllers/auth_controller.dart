import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_app/data/api_service.dart';
import 'package:tailor_app/routes/app_routes.dart';
import 'package:tailor_app/screens/main_wrapper.dart';
import 'package:tailor_app/controllers/profile_controller.dart';

class AuthController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Register specific
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;

  // Visibility toggles
  final isLoginPasswordHidden = true.obs;
  final isRegisterPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;

  Future<void> login() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    try {
      isLoading.value = true;
      await _apiService.login(usernameController.text, passwordController.text);

      Get.snackbar('Success', 'Login successful');

      // Refresh to load profile with new token
      try {
        final profileController = Get.find<ProfileController>();
        await profileController.getUserProfile();
      } catch (_) {}

      Get.offAll(() => const MainWrapper());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    try {
      isLoading.value = true;
      // Defaulting to Customer register for now
      await _apiService.registerCustomer({
        'username': usernameController.text,
        'password': passwordController.text,
        're_password': confirmPasswordController.text,
      });

      Get.snackbar(
        'Success',
        'Registration successful. Please login.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        duration: const Duration(seconds: 3),
      );

      // Wait for snackbar to be seen
      await Future.delayed(const Duration(seconds: 2));
      clearFields();
      Get.offAllNamed(
        AppRoutes.login,
      ); // Explicitly go to Login, clearing stack
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void clearFields() {
    usernameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
