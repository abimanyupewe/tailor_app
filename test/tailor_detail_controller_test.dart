// ignore_for_file: must_call_super

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tailor_app/controllers/tailor_detail_controller.dart';
import 'package:tailor_app/data/api_service.dart';
import 'package:tailor_app/models/tailor_model.dart';

/// Mirrors the real backend: the detail endpoint has no `distance` field and
/// returns a null `location`.
class _FakeApiService extends ApiService {
  @override
  void onInit() {
    // Intentionally skip ApiService.onInit (dotenv/token loading).
    baseUrl = 'http://localhost';
  }

  @override
  Future<dynamic> getTailorDetail(String id) async {
    return {
      'id': 4,
      'shop_name': "pak_joko's Shop",
      'is_verified': true,
      'location': null,
      'services': [],
      'posts': [],
      'user': {'id': 6, 'phone_number': '0864837461'},
    };
  }

  @override
  Future<dynamic> getReviews(String tailorId) async => [];
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(Get.reset);

  test('jarak dari list tidak hilang saat detail di-refresh', () async {
    Get.put<ApiService>(_FakeApiService());

    final initial = Tailor(
      id: '4',
      name: "pak_joko's Shop",
      address: 'Jl. Mawar No. 1',
      rating: 4.5,
      reviewCount: 3,
      imageUrl: '',
      latitude: -7.05,
      longitude: 110.44,
      distance: 260.12,
      isVerified: true,
      services: [],
      reviews: [],
      phoneNumber: '0864837461',
      posts: [],
    );

    final controller = TailorDetailController(initial);
    await controller.refreshTailor();

    expect(controller.tailor.value.distance, 260.12);
    expect(controller.tailor.value.formattedDistance, '260.1 km');
    expect(controller.tailor.value.address, 'Jl. Mawar No. 1');
    expect(controller.tailor.value.latitude, -7.05);
  });

  test('jarak dekat tampil dalam meter', () {
    final tailor = Tailor(
      id: '1',
      name: 'A',
      address: 'B',
      rating: 0,
      reviewCount: 0,
      imageUrl: '',
      latitude: 0,
      longitude: 0,
      distance: 0.85,
      isVerified: false,
      services: [],
      reviews: [],
      phoneNumber: '-',
      posts: [],
    );

    expect(tailor.formattedDistance, '850 m');
  });
}
