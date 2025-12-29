import 'package:get/get.dart';
import 'package:tailor_app/models/tailor_model.dart';
import 'package:tailor_app/data/api_service.dart';

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
    try {
      final apiService = Get.find<ApiService>();
      final List<dynamic> response = await apiService.getTailors();

      if (response.isNotEmpty) {
        final List<Tailor> data = response
            .map((json) => Tailor.fromJson(json))
            .toList();
        tailors.assignAll(data);
      } else {
        tailors.clear();
      }
    } catch (e) {
      print("Error loading tailors: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
