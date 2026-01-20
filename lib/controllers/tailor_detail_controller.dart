import 'package:get/get.dart';
import 'package:tailor_app/data/api_service.dart';
import 'package:tailor_app/models/tailor_model.dart';

class TailorDetailController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  late Rx<Tailor> tailor;
  final RxList<Review> reviews = <Review>[].obs;

  TailorDetailController(Tailor initialTailor) {
    tailor = initialTailor.obs;
    reviews.assignAll(initialTailor.reviews);
  }

  @override
  void onInit() {
    super.onInit();
    // Refresh data immediately to get latest info & full reviews
    refreshTailor();
  }

  Future<void> refreshTailor() async {
    try {
      final data = await _apiService.getTailorDetail(tailor.value.id);
      tailor.value = Tailor.fromJson(data);

      // Also fetch reviews specifically to ensure we have the full list
      try {
        final reviewsData = await _apiService.getReviews(tailor.value.id);
        if (reviewsData is List) {
          final reviewList = <Review>[];
          for (var r in reviewsData) {
            try {
              reviewList.add(Review.fromJson(r));
            } catch (e) {
              print("Error parsing individual review: $e");
            }
          }
          reviews.assignAll(reviewList);
        } else if (reviewsData is Map && reviewsData.containsKey('results')) {
          final reviewList = <Review>[];
          for (var r in reviewsData['results'] as List) {
            try {
              reviewList.add(Review.fromJson(r));
            } catch (e) {
              print("Error parsing individual review: $e");
            }
          }
          reviews.assignAll(reviewList);
        }
      } catch (e) {
        print("Error refreshing reviews: $e");
        // Fallback to what's in the tailor object if separate fetch fails
        reviews.assignAll(tailor.value.reviews);
      }
    } catch (e) {
      print("Error refreshing tailor: $e");
    }
  }
}
