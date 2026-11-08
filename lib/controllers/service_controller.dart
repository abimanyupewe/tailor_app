import 'package:get/get.dart';
import 'package:tailor_app/data/api_service.dart';
import 'package:tailor_app/models/tailor_model.dart';

class ServiceController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final RxList<Service> services = <Service>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadServices();
  }

  Future<void> loadServices() async {
    isLoading.value = true;
    try {
      final data = await _apiService.getMyServices();
      final List<dynamic> list;
      if (data is Map && data['results'] is List) {
        list = List<dynamic>.from(data['results']);
      } else if (data is List) {
        list = data;
      } else {
        list = const [];
      }
      services.assignAll(list.map((e) => Service.fromJson(e)).toList());
    } finally {
      isLoading.value = false;
    }
  }

  /// Creates a new service when [existing] is null, otherwise updates it.
  /// Returns the error message on failure, or null on success.
  Future<String?> save({
    Service? existing,
    required String name,
    required double price,
    required String description,
    required int durationDays,
    required bool isActive,
  }) async {
    isSaving.value = true;
    try {
      final payload = {
        'name': name,
        'base_price': price.toStringAsFixed(2),
        'description': description,
        'estimated_duration_days': durationDays,
        'is_active': isActive,
      };
      if (existing == null) {
        await _apiService.addService(payload);
      } else {
        await _apiService.updateService(existing.id, payload);
      }
      await loadServices();
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    } finally {
      isSaving.value = false;
    }
  }

  /// Returns the error message on failure, or null on success.
  Future<String?> remove(Service service) async {
    try {
      await _apiService.deleteService(service.id);
      services.removeWhere((s) => s.id == service.id);
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }
}
