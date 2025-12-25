import 'package:get/get.dart';
import 'package:tailor_app/controllers/auth_controller.dart';
import 'package:tailor_app/controllers/slider_controller.dart';
import 'package:tailor_app/controllers/tailor_controller.dart';
import 'package:tailor_app/controllers/profile_controller.dart';
import 'package:tailor_app/data/api_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiService());
    Get.put<SliderController>(SliderController(), permanent: true);
    Get.put(AuthController());
    Get.put(ProfileController());
    Get.put<TailorController>(TailorController(), permanent: true);
  }
}
