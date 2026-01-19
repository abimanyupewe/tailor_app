import 'package:get/get.dart';
import 'package:tailor_app/controllers/profile_controller.dart';

class NavigationController extends GetxController {
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
    if (index == 4) {
      // Refresh profile when tapping the profile tab
      try {
        Get.find<ProfileController>().getUserProfile();
      } catch (_) {}
    }
  }
}
