import 'package:get/get.dart';
import 'package:tailor_app/data/api_service.dart';

class ProfileController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final user = Rxn<Map<String, dynamic>>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (_apiService.isAuthenticated) {
      getUserProfile();
    }
  }

  Future<void> getUserProfile() async {
    if (!_apiService.isAuthenticated) {
      print('ProfileController: Not authenticated, skipping fetch.');
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await _apiService.getProfile();
      user.value = response;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
