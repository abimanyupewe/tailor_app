import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_app/controllers/map_controller.dart';

class SearchInputWidget extends StatelessWidget {
  const SearchInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mapController = Get.find<MapControllerX>();

    return Column(
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
    );
  }
}
