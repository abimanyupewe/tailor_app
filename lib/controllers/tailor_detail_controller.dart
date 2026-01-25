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
      print("TailorDetailController: Refreshing tailor ${tailor.value.id}");
      final data = await _apiService.getTailorDetail(tailor.value.id);
      print("TailorDetailController: Detail data received: $data");
      tailor.value = Tailor.fromJson(data);

      try {
        final reviewsData = await _apiService.getReviews(tailor.value.id);
        print("TailorDetailController: Reviews data received: $reviewsData");
        List<Review> fetchedReviews = [];

        if (reviewsData is List) {
          for (var r in reviewsData) {
            try {
              fetchedReviews.add(Review.fromJson(r));
            } catch (e) {
              print("Error parsing individual review: $e");
            }
          }
        } else if (reviewsData is Map && reviewsData.containsKey('results')) {
          for (var r in reviewsData['results'] as List) {
            try {
              fetchedReviews.add(Review.fromJson(r));
            } catch (e) {
              print("Error parsing individual review: $e");
            }
          }
        }

        // Update tailor with fetched reviews to ensure rating calculation works
        if (fetchedReviews.isNotEmpty) {
          final currentRating = tailor.value.rating;
          // Calculate if current is 0
          final newRating = currentRating == 0.0
              ? fetchedReviews.map((r) => r.rating).fold(0.0, (a, b) => a + b) /
                    fetchedReviews.length
              : currentRating;

          tailor.value = Tailor(
            id: tailor.value.id,
            userId: tailor.value.userId,
            name: tailor.value.name,
            address: tailor.value.address,
            rating: newRating,
            reviewCount: fetchedReviews.length,
            imageUrl: tailor.value.imageUrl,
            latitude: tailor.value.latitude,
            longitude: tailor.value.longitude,
            distance: tailor.value.distance,
            services: tailor.value.services,
            reviews: fetchedReviews,
            phoneNumber: tailor.value.phoneNumber,
            posts: tailor.value.posts,
          );
        }
        reviews.assignAll(fetchedReviews);
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
