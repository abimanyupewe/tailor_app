import 'package:get/get.dart';
import 'package:tailor_app/data/dataDummy.dart';
import 'package:tailor_app/data/models/slider_model.dart';

class SliderController extends GetxController {
  final RxList<SliderModel> sliders = <SliderModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  Future<void> loadInitial() async {
    isLoading.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final dummy = DataSlider().data;
    sliders.assignAll(dummy.map((e) => SliderModel.fromJson(e)));
    isLoading.value = false;
  }
}



