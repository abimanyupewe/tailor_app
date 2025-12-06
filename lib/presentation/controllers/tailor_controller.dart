import 'package:get/get.dart';
import 'package:tailor_app/data/models/tailor_model.dart';
import 'package:tailor_app/data/repositories/tailor_repository.dart';

class TailorController extends GetxController {
  final RxList<Tailor> tailors = <Tailor>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  Future<void> loadInitial() async {
    isLoading.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final data = TailorRepository.getTailors();
    tailors.assignAll(data);
    isLoading.value = false;
  }
}
