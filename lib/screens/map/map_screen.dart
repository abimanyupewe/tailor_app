import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_app/controllers/map_controller.dart';
import 'package:tailor_app/screens/map/widgets/map_view.dart';
import 'package:tailor_app/screens/map/widgets/route_timeline_widget.dart';
import 'package:tailor_app/screens/map/widgets/search_input_widget.dart';
import 'package:tailor_app/screens/map/widgets/tailor_detail_sheet.dart';
import 'package:tailor_app/screens/map/widgets/tailor_list_sheet.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mapController = Get.put(MapControllerX());

    return Scaffold(
      body: Stack(
        children: [
          const MapView(),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Obx(() {
              if (mapController.selectedTailor.value != null) {
                return const RouteTimelineWidget();
              } else {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SearchInputWidget(),
                );
              }
            }),
          ),
          Obx(() {
            final selected = mapController.selectedTailor.value;
            if (selected != null) {
              return TailorDetailSheet(selected: selected);
            } else {
              return const TailorListSheet();
            }
          }),
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
