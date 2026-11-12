import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_app/controllers/map_controller.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/screens/map/widgets/map_view.dart';
import 'package:tailor_app/screens/map/widgets/search_input_widget.dart';
import 'package:tailor_app/screens/map/widgets/tailor_detail_sheet.dart';
import 'package:tailor_app/screens/map/widgets/tailor_list_sheet.dart';
import 'package:tailor_app/l10n/generated/app_localizations.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mapController = Get.put(MapControllerX());
    final l10n = AppLocalizations.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.navMap),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(112),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: SearchInputWidget(showSuggestions: false),
                ),
                TabBar(
                  onTap: (index) {
                    if (index == 0) mapController.clearSelection();
                  },
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: [
                    Tab(text: l10n.navMap),
                    Tab(text: l10n.nearbyTailors),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Stack(
              children: [
                const MapView(),
                const Positioned(
                  top: 8,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: SearchSuggestionsWidget(),
                  ),
                ),
                Obx(() {
                  final selected = mapController.selectedTailor.value;
                  if (selected != null) {
                    return TailorDetailSheet(selected: selected);
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
            const TailorListSheet(fullScreen: true),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: mapController.moveToCurrentLocation,
          backgroundColor: Colors.white,
          elevation: 0,
          shape: const CircleBorder(
            side: BorderSide(color: AppColors.secondary),
          ),
          child: const Icon(Iconsax.gps, color: AppColors.primary),
        ),
      ),
    );
  }
}
