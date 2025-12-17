import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:tailor_app/services/map_repository.dart';

class MapControllerX extends GetxController {
  final MapRepository _repository = MapRepository();
  final mapController = MapController();
  final searchController = TextEditingController();

  final Rx<LatLng?> currentLocation = Rx<LatLng?>(null);
  final RxList<Map<String, dynamic>> searchResults =
      <Map<String, dynamic>>[].obs;
  final RxBool isSearching = false.obs;
  final RxBool showSuggestions = false.obs;
  final RxString searchText = ''.obs;

  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    _initializeLocation();
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    searchController.dispose();
    super.onClose();
  }

  Future<void> _initializeLocation() async {
    try {
      final position = await _repository.getCurrentLocation();
      currentLocation.value = LatLng(position.latitude, position.longitude);
      // mapController.move(currentLocation.value!, 15); // Optional: Auto-center
    } catch (e) {
      Get.snackbar('Location Error', e.toString());
    }
  }

  void onSearchChanged(String query) {
    searchText.value = query;
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    if (query.length < 3) {
      searchResults.clear();
      showSuggestions.value = false;
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 800), () async {
      isSearching.value = true;
      try {
        final results = await _repository.searchLocation(query);
        searchResults.assignAll(results);
        showSuggestions.value = true;
      } catch (e) {
        Get.snackbar('Search Error', e.toString());
        searchResults.clear();
      } finally {
        isSearching.value = false;
      }
    });
  }

  void selectLocation(double lat, double lon, String displayName) {
    final location = LatLng(lat, lon);
    mapController.move(location, 15);
    searchController.text = displayName;
    showSuggestions.value = false;
    // Optional: Set a destination marker or similar
  }

  void moveToCurrentLocation() {
    if (currentLocation.value != null) {
      mapController.move(currentLocation.value!, 15);
    } else {
      _initializeLocation();
    }
  }
}
