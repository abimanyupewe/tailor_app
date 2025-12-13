import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:latlong2/latlong.dart';
import 'package:tailor_app/presentation/controllers/map_controller.dart';
import 'package:tailor_app/presentation/controllers/tailor_controller.dart';
import 'package:tailor_app/presentation/screens/tailor/tailor_detail_screen.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tailorController = Get.find<TailorController>();
    final mapController = Get.put(MapControllerX());

    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            if (mapController.currentLocation.value == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return FlutterMap(
              mapController: mapController.mapController,
              options: MapOptions(
                initialCenter: mapController.currentLocation.value!,
                initialZoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.tailor_app',
                ),
                CurrentLocationLayer(
                  style: LocationMarkerStyle(
                    marker: const DefaultLocationMarker(
                      color: Colors.deepPurple,
                      child: Icon(
                        Icons.navigation,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    markerSize: const Size(40, 40),
                    markerDirection: MarkerDirection.heading,
                  ),
                ),
                MarkerLayer(
                  markers: tailorController.tailors.map((tailor) {
                    return Marker(
                      point: LatLng(tailor.latitude, tailor.longitude),
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => TailorDetailScreen(tailor: tailor));
                        },
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          }),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Column(
              children: [
                TextField(
                  controller: mapController.searchController,
                  onChanged: mapController.onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search location...',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Iconsax.search_normal),
                    suffixIcon: Obx(
                      () => mapController.searchText.value.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                mapController.searchController.clear();
                                mapController.searchText.value = '';
                                mapController.searchResults.clear();
                                mapController.showSuggestions.value = false;
                              },
                            )
                          : const SizedBox(),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                Obx(
                  () =>
                      mapController.showSuggestions.value &&
                          mapController.searchResults.isNotEmpty
                      ? Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          constraints: const BoxConstraints(maxHeight: 250),
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: mapController.searchResults.length,
                            itemBuilder: (context, index) {
                              final result = mapController.searchResults[index];
                              return ListTile(
                                leading: const Icon(Iconsax.location),
                                title: Text(
                                  result['display_name'] ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () {
                                  mapController.selectLocation(
                                    double.parse(result['lat']),
                                    double.parse(result['lon']),
                                    result['display_name'] ?? '',
                                  );
                                },
                              );
                            },
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: mapController.moveToCurrentLocation,
        backgroundColor: Colors.white,
        child: const Icon(Iconsax.gps, color: Colors.black),
      ),
    );
  }
}
