import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:tailor_app/controllers/map_controller.dart';
import 'package:tailor_app/controllers/tailor_controller.dart';
import 'package:tailor_app/data/api_service.dart';
import 'package:tailor_app/core/constants/app_colors.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    final mapController = Get.find<MapControllerX>();
    final tailorController = Get.find<TailorController>();

    return Obx(() {
      if (mapController.currentLocation.value == null) {
        return const Center(child: CircularProgressIndicator(color: AppColors.primary));
      }

      return FlutterMap(
        mapController: mapController.mapController,
        options: MapOptions(
          initialCenter: mapController.currentLocation.value!,
          initialZoom: 13.0,
          onTap: (_, __) => mapController.clearSelection(),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.tailor_app',
          ),
          CurrentLocationLayer(
            style: LocationMarkerStyle(
              marker: const PulsingLocationMarker(),
              markerSize: const Size(60, 60),
              markerDirection: MarkerDirection.heading,
            ),
          ),
          if (mapController.isRoutingMode.value &&
              mapController.selectedTailor.value != null &&
              mapController.currentLocation.value != null)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: mapController.routePoints.isNotEmpty
                      ? mapController.routePoints
                      : [
                          mapController.currentLocation.value!,
                          LatLng(
                            mapController.selectedTailor.value!.latitude,
                            mapController.selectedTailor.value!.longitude,
                          ),
                        ],
                  strokeWidth: 4.0,
                  color: AppColors.secondary,
                  pattern: mapController.routePoints.isNotEmpty
                      ? const StrokePattern.solid()
                      : const StrokePattern.dotted(),
                ),
              ],
            ),
          MarkerLayer(
            markers: tailorController.tailors.map((tailor) {
              return Marker(
                point: LatLng(tailor.latitude, tailor.longitude),
                width: 80,
                height: 80,
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () => mapController.selectTailor(tailor),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.secondary,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            Get.find<ApiService>().getImageUrl(tailor.imageUrl),
                            width: 36,
                            height: 36,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.store,
                              size: 24,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.secondary,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );
    });
  }
}

class PulsingLocationMarker extends StatefulWidget {
  const PulsingLocationMarker({super.key});

  @override
  State<PulsingLocationMarker> createState() => _PulsingLocationMarkerState();
}

class _PulsingLocationMarkerState extends State<PulsingLocationMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Comfortable slow breath
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // Gradient: Soft purple to transparent edge
            gradient: RadialGradient(
              colors: [
                AppColors.secondary.withValues(alpha: 0.8), // Inner core
                AppColors.secondary.withValues(alpha: 0.1), // Outer edge
              ],
              stops: const [0.3, 1.0],
            ),
            // Subtle Outline
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.5),
              width: 1.5,
            ),
            // Multiple soft shadows for "Solar Scan" feel
          ),
          child: const Center(
            child: Icon(
              Icons.navigation_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        );
      },
    );
  }
}
