import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailor_app/data/api_service.dart';
import 'package:tailor_app/core/utils/app_toast.dart';

class ProfileController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final ImagePicker _picker = ImagePicker();

  final user = Rxn<Map<String, dynamic>>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Edit Profile State
  final Rx<File?> selectedImage = Rx<File?>(null);
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (_apiService.isAuthenticated) {
      getUserProfile();
    }
  }

  Future<void> getUserProfile() async {
    if (!_apiService.isAuthenticated) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await _apiService.getProfile();
      user.value = response;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      AppToast.error('Failed to pick image: $e');
    }
  }

  Future<void> updateUserProfile({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String address,
    required String email,
  }) async {
    try {
      isSaving.value = true;

      final Map<String, String> data = {
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber,
        'address': address,
        'email': email,
      };

      await _apiService.updateProfileMultipart(
        data: data,
        imageFile: selectedImage.value,
      );

      // Refresh profile data
      await getUserProfile();

      Get.back(); // Close edit screen
      AppToast.success('Profile updated successfully!');

      // Reset image selection
      selectedImage.value = null;
    } catch (e) {
      AppToast.error('Failed to update profile: $e');
    } finally {
      isSaving.value = false;
    }
  }
}
