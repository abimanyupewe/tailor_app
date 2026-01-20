import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_app/controllers/map_controller.dart';
import 'package:tailor_app/models/tailor_model.dart';

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
                      final isTailor = result['type'] == 'TAILOR';

                      return ListTile(
                        leading: Icon(
                          isTailor ? Iconsax.shop : Iconsax.location,
                          color: isTailor ? Colors.deepPurple : Colors.grey,
                        ),
                        title: Text(
                          result['display_name'] ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: isTailor
                            ? const Text(
                                "Tailor Shop",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              )
                            : null,
                        onTap: () {
                          if (isTailor) {
                            // Convert back to Tailor object
                            final tailor = Tailor.fromJson(result['data']);
                            mapController.selectTailor(tailor);
                            // Clear search
                            mapController.searchController.clear();
                            mapController.searchText.value = '';
                            mapController.searchResults.clear();
                            mapController.showSuggestions.value = false;
                          } else {
                            mapController.selectLocation(
                              double.parse(result['lat']),
                              double.parse(result['lon']),
                              result['display_name'] ?? '',
                            );
                          }
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
