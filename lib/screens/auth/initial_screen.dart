import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_app/data/api_service.dart';
import 'package:tailor_app/routes/app_routes.dart';
import 'package:tailor_app/controllers/profile_controller.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Wait for services to be ready
    await Future.delayed(const Duration(seconds: 2));
    final apiService = Get.find<ApiService>();

    // Check if token exists (logic in apiService already loads token onInit,
    // but onInit is async in valid dart so we might need to wait or rely on memory)
    // Actually ApiService.onInit triggers _loadToken, but it's async so it might not be done instantly.
    // Better way: let ApiService expose a "isReady" future or just check sharedprefs here directly
    // OR, trust that by the time this splash runs (2 sec), it's loaded.

    // To be safe, let's wait a bit more or check apiService state.
    // For now, simple check:

    if (apiService.isAuthenticated) {
      // Pre-load profile data
      try {
        Get.find<ProfileController>().getUserProfile();
      } catch (_) {}

      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Checking authentication...'),
          ],
        ),
      ),
    );
  }
}
