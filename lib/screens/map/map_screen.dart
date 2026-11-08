import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_app/controllers/map_controller.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
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
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Obx(() {
                  final hasSelection =
                      mapController.selectedTailor.value != null;
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: hasSelection
                        ? const RouteTimelineWidget(key: ValueKey('route'))
                        : const Padding(
                            key: ValueKey('search'),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: SearchInputWidget(),
                          ),
                  );
                }),
              ),
            ),
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
        elevation: 0,
        shape: const CircleBorder(side: BorderSide(color: AppColors.secondary)),
        child: const Icon(Iconsax.gps, color: AppColors.primary),
      ),
    );
  }
}
