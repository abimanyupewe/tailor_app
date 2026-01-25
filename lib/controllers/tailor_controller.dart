import 'package:get/get.dart';
import 'package:tailor_app/models/tailor_model.dart';
import 'package:tailor_app/data/api_service.dart';

class TailorController extends GetxController {
  final RxList<Tailor> tailors = <Tailor>[].obs;
  final RxList<Tailor> popularTailors = <Tailor>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAllTailors();
  }

  Future<void> getAllTailors() async {
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

      // Fetch popular tailors (ordered by order_count desc)
      try {
        final List<dynamic> popResponse = await apiService.getTailors(
          ordering: '-order_count',
        );
        if (popResponse.isNotEmpty) {
          final List<Tailor> popData = popResponse
              .map((json) => Tailor.fromJson(json))
              .toList();
          popularTailors.assignAll(popData);
        }
      } catch (e) {
        print("Error loading popular tailors: $e");
      }
    } catch (e) {
      print("Error loading tailors: $e");
    } finally {
      isLoading.value = false;
      // Fetch missing ratings in background after list is shown
      fetchMissingRatings();
    }
  }

  Future<void> fetchMissingRatings() async {
    await Future.wait([_fetchForList(tailors), _fetchForList(popularTailors)]);
  }

  Future<void> _fetchForList(RxList<Tailor> list) async {
    for (int i = 0; i < list.length; i++) {
      final tailor = list[i];
      if (tailor.rating == 0.0) {
        try {
          final apiService = Get.find<ApiService>();
          final reviewsData = await apiService.getReviews(tailor.id);
          List<dynamic> reviews = [];
          if (reviewsData is List) {
            reviews = reviewsData;
          } else if (reviewsData is Map && reviewsData.containsKey('results')) {
            reviews = reviewsData['results'];
          }

          if (reviews.isNotEmpty) {
            double total = 0.0;
            int count = reviews.length;
            for (var r in reviews) {
              final reviewModel = Review.fromJson(r);
              total += reviewModel.rating;
            }
            final double avg = total / count;

            final updatedTailor = Tailor(
              id: tailor.id,
              userId: tailor.userId,
              name: tailor.name,
              address: tailor.address,
              rating: avg,
              reviewCount: count,
              imageUrl: tailor.imageUrl,
              latitude: tailor.latitude,
              longitude: tailor.longitude,
              distance: tailor.distance,
              services: tailor.services,
              reviews: reviews.map((r) => Review.fromJson(r)).toList(),
              phoneNumber: tailor.phoneNumber,
              posts: tailor.posts,
            );

            list[i] = updatedTailor;
          }
        } catch (e) {
          print("Error fetching rating for tailor ${tailor.name}: $e");
        }
      }
    }
  }
}
