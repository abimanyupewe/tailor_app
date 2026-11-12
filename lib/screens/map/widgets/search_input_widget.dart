import 'package:flutter/material.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_app/controllers/map_controller.dart';
import 'package:tailor_app/models/tailor_model.dart';
import 'package:tailor_app/l10n/generated/app_localizations.dart';

class SearchInputWidget extends StatelessWidget {
  final bool showSuggestions;

  const SearchInputWidget({super.key, this.showSuggestions = true});

  @override
  Widget build(BuildContext context) {
    final mapController = Get.find<MapControllerX>();
    final l10n = AppLocalizations.of(context);

    final input = TextField(
      controller: mapController.searchController,
      onChanged: mapController.onSearchChanged,
      decoration: InputDecoration(
        hintText: l10n.searchLocationHint,
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
          borderSide: BorderSide(
            color: AppColors.secondary.withValues(alpha: 0.15),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );

    if (!showSuggestions) return input;

    return Column(
      children: [
        input,
        const SizedBox(height: 8),
        const SearchSuggestionsWidget(),
      ],
    );
  }
}

class SearchSuggestionsWidget extends StatelessWidget {
  const SearchSuggestionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mapController = Get.find<MapControllerX>();
    final l10n = AppLocalizations.of(context);

    return Obx(() {
      if (!mapController.showSuggestions.value) {
        return const SizedBox.shrink();
      }
      if (mapController.searchResults.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: _dropdownDecoration(),
          child: Row(
            children: [
              Icon(Icons.search_off, size: 18, color: Colors.grey.shade500),
              const SizedBox(width: 10),
              Text(
                l10n.noTailorsFound,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
        );
      }
      return Container(
        decoration: _dropdownDecoration(),
        constraints: const BoxConstraints(maxHeight: 250),
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: mapController.searchResults.length,
          separatorBuilder: (_, __) =>
              Divider(height: 1, color: Colors.grey.shade100),
          itemBuilder: (context, index) {
            final result = mapController.searchResults[index];
            final isTailor = result['type'] == 'TAILOR';

            return ListTile(
              dense: true,
              leading: Icon(
                isTailor ? Iconsax.shop : Iconsax.location,
                color: isTailor ? AppColors.secondary : Colors.grey,
              ),
              title: Text(
                result['display_name'] ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
              subtitle: isTailor
                  ? Text(
                      l10n.tailorShop,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    )
                  : null,
              onTap: () {
                if (isTailor) {
                  final tailor = Tailor.fromJson(result['data']);
                  mapController.selectTailor(tailor);
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
      );
    });
  }

  BoxDecoration _dropdownDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.secondary.withValues(alpha: 0.12)),
    );
  }
}
