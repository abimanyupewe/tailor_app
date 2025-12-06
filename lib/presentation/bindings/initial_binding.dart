import 'package:get/get.dart';
import 'package:tailor_app/presentation/controllers/slider_controller.dart';
import 'package:tailor_app/presentation/controllers/tailor_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SliderController>(SliderController(), permanent: true);
    Get.put<TailorController>(TailorController(), permanent: true);
  }
}



