import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:tailor_app/models/tailor_model.dart';
import 'package:tailor_app/screens/map/widgets/arrival_dialog.dart';
import 'package:tailor_app/services/map_repository.dart';

class MapControllerX extends GetxController {
  final MapRepository _repository = MapRepository();
  final mapController = MapController();
  final searchController = TextEditingController();
  final DraggableScrollableController sheetController =
      DraggableScrollableController();

  final Rx<Tailor?> selectedTailor = Rx<Tailor?>(null);
  final RxBool isRoutingMode = false.obs;
  final RxList<LatLng> routePoints = <LatLng>[].obs;

  StreamSubscription<Position>? _positionStreamSubscription;

  void selectTailor(Tailor tailor) {
    selectedTailor.value = tailor;
    isRoutingMode.value = false;
    routePoints.clear();
    // Animate sheet to open state if needed, or just let UI react
    if (sheetController.isAttached) {
      sheetController.animateTo(
        0.45, // Open to 30% or desired height
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
    // Center map on tailor
    mapController.move(LatLng(tailor.latitude, tailor.longitude), 15);
  }

  void clearSelection() {
    selectedTailor.value = null;
    isRoutingMode.value = false;
    routePoints.clear();
    if (sheetController.isAttached) {
      sheetController.animateTo(
        0.3, // Collapse to min size
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> toggleRouting() async {
    isRoutingMode.value = !isRoutingMode.value;

    if (isRoutingMode.value) {
      if (currentLocation.value != null && selectedTailor.value != null) {
        // Fetch route
        try {
          final points = await _repository.getRoute(
            currentLocation.value!.latitude,
            currentLocation.value!.longitude,
            selectedTailor.value!.latitude,
            selectedTailor.value!.longitude,
          );

          if (points.isNotEmpty) {
            routePoints.assignAll(
              points.map((p) => LatLng(p[0], p[1])).toList(),
            );
          }
        } catch (e) {
          Get.snackbar("Error", "Failed to load route");
          isRoutingMode.value = false;
        }

        // Fit bounds
        mapController.fitCamera(
          CameraFit.coordinates(
            coordinates: [
              currentLocation.value!,
              LatLng(
                selectedTailor.value!.latitude,
                selectedTailor.value!.longitude,
              ),
            ],
            padding: const EdgeInsets.all(80),
          ),
        );
      }
    } else {
      routePoints.clear();
    }
  }

  @override
  void onClose() {
    _positionStreamSubscription?.cancel();
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
    _startPositionStream();
  }

  void _startPositionStream() {
    // Listen to location updates
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStreamSubscription =
        Geolocator.getPositionStream(
          locationSettings: locationSettings,
        ).listen((Position position) {
          final lat = position.latitude;
          final lon = position.longitude;
          currentLocation.value = LatLng(lat, lon);

          // We only update address once on init (via _initializeLocation) to save API calls
          // but we could update it here if needed.

          _checkArrival();
        });
  }

  void _checkArrival() {
    if (!isRoutingMode.value ||
        selectedTailor.value == null ||
        currentLocation.value == null)
      return;

    final distance = const Distance().as(
      LengthUnit.Meter,
      currentLocation.value!,
      LatLng(selectedTailor.value!.latitude, selectedTailor.value!.longitude),
    );

    if (distance < 50) {
      // 50 meters threshold
      isRoutingMode.value = false;
      routePoints.clear();

      Get.dialog(
        ArrivalDialog(
          tailorName: selectedTailor.value!.name,
          onReview: () {
            // Placeholder: Navigate to detail/review page if needed
            // For now, we remain on map.
            // Ideally trigger open detail sheet on review tab
          },
        ),
      );
    }
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
