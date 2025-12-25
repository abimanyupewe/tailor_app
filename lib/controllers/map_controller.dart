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

  @override
  void onClose() {
    _debounceTimer?.cancel();
    searchController.dispose();
    super.onClose();
  }

  final Rx<LatLng?> currentLocation = Rx<LatLng?>(null);
  final RxList<Map<String, dynamic>> searchResults =
      <Map<String, dynamic>>[].obs;
  final RxBool isSearching = false.obs;
  final RxBool showSuggestions = false.obs;
  final RxString searchText = ''.obs;

  Timer? _debounceTimer;

  final RxString currentAddress = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeLocation();
  }

  // Expose method to manually update address
  Future<void> updateAddress(double lat, double lon) async {
    try {
      final address = await _repository.getAddressFromCoordinates(lat, lon);
      currentAddress.value = address;
    } catch (_) {
      currentAddress.value = 'Location not found';
    }
  }

  Future<void> _initializeLocation() async {
    try {
      final position = await _repository.getCurrentLocation();
      final lat = position.latitude;
      final lon = position.longitude;

      currentLocation.value = LatLng(lat, lon);
      await updateAddress(lat, lon);

      // mapController.move(currentLocation.value!, 15); // Optional: Auto-center
    } catch (e) {
      // Don't show snackbar on init to avoid spamming if permission denied initially
      print('Location Init Error: $e');
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
