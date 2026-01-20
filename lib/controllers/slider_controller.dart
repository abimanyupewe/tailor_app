import 'package:get/get.dart';
import 'package:tailor_app/models/slider_model.dart';
import 'package:tailor_app/data/dummy_data.dart';

class SliderController extends GetxController {
  final RxList<SliderModel> sliders = <SliderModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getSliders();
  }

  Future<void> getSliders() async {
    isLoading.value = true;
    try {
      /*
      final apiService = Get.find<ApiService>();
      final response = await apiService.getSliders();

      if (response != null && response is List) {
        sliders.assignAll(
          response.map((e) => SliderModel.fromJson(e)).toList(),
        );
      } else {
        sliders.clear();
      }
      */

      // RESTORE DUMMY DATA
      // Need to map DataSlider map to SliderModel
      // Assuming SliderModel has appropriate fromJson/constructors
      // But wait, dummy data has specific fields: imageUrl, color, etc.
      // Let's import dummy_data first.

      final dummyData = DataSlider().data;
      sliders.assignAll(
        dummyData
            .map(
              (e) => SliderModel(
                id: e['id'],
                imageUrl: e['imageUrl'],
                link: e['link'],
                color: e['color'],
                textAction: e['textAction'],
                title: e['title'],
                description: e['description'],
              ),
            )
            .toList(),
      );
    } catch (e) {
      print('Error loading sliders: $e');
      sliders.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
