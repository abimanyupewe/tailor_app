import 'package:flutter/foundation.dart';
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
      final fetched = Tailor.fromJson(data);

      // The detail endpoint omits `distance` and often returns a null
      // `location`; keep the list-derived values instead of resetting to 0.
      final hasLocation =
          fetched.address != 'No Address' || fetched.latitude != 0;
      tailor.value = fetched.copyWith(
        address: hasLocation ? fetched.address : tailor.value.address,
        latitude: hasLocation ? fetched.latitude : tailor.value.latitude,
        longitude: hasLocation ? fetched.longitude : tailor.value.longitude,
        distance: fetched.distance > 0
            ? fetched.distance
            : tailor.value.distance,
      );

      try {
        final reviewsData = await _apiService.getReviews(tailor.value.id);
        List<Review> fetchedReviews = [];

        if (reviewsData is List) {
          for (var r in reviewsData) {
            try {
              fetchedReviews.add(Review.fromJson(r));
            } catch (e) {
              debugPrint("Error parsing individual review: $e");
            }
          }
        } else if (reviewsData is Map && reviewsData.containsKey('results')) {
          for (var r in reviewsData['results'] as List) {
            try {
              fetchedReviews.add(Review.fromJson(r));
            } catch (e) {
              debugPrint("Error parsing individual review: $e");
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
            isVerified: tailor.value.isVerified,
            services: tailor.value.services,
            reviews: fetchedReviews,
            phoneNumber: tailor.value.phoneNumber,
            posts: tailor.value.posts,
          );
        }
        reviews.assignAll(fetchedReviews);
      } catch (e) {
        debugPrint("Error refreshing reviews: $e");
        // Fallback to what's in the tailor object if separate fetch fails
        reviews.assignAll(tailor.value.reviews);
      }
    } catch (e) {
      debugPrint("Error refreshing tailor: $e");
    }
  }
}
