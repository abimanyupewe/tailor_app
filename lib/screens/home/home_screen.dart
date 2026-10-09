import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/core/constants/image_string.dart';
import 'package:tailor_app/data/dummy_data.dart';
import 'package:tailor_app/controllers/slider_controller.dart';
import 'package:tailor_app/controllers/tailor_controller.dart';
import 'package:tailor_app/controllers/profile_controller.dart';
import 'package:tailor_app/data/api_service.dart';
import 'package:tailor_app/widgets/category_hori.dart';
import 'package:tailor_app/widgets/slider_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tailor_app/controllers/map_controller.dart';
import 'package:tailor_app/models/tailor_model.dart';
import 'package:tailor_app/controllers/locale_controller.dart';
import 'package:tailor_app/l10n/generated/app_localizations.dart';
import 'package:tailor_app/widgets/tailor_card.dart';
import 'package:tailor_app/widgets/skeleton.dart';
import 'package:tailor_app/screens/category/all_categories_screen.dart';
import 'package:tailor_app/screens/search/search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    final apiService = Get.find<ApiService>();
    final sliderController = Get.find<SliderController>();
    final tailorController = Get.find<TailorController>();
    // Initialize MapController to fetch realtime location
    final mapController = Get.put(MapControllerX());
    final categoryData = DataCategory().data;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Builder(
        builder: (context) => Obx(() {
        final l10n = AppLocalizations.of(context);
        // Resubscribe so this Obx rebuilds (fresh strings) on language switch.
        Get.find<LocaleController>().locale.value;
        final userData = profileController.user.value;
        final userObj = userData?['user'];
        final avatarUrl = userObj?['avatar'];
        final username = userObj?['username'] ?? 'User';

        // Priority: 1. Realtime GPS Address (Home should reflect current loc), 2. Fallback
        String displayAddress = l10n.findingLocation;

        // Use Obx observation of mapController
        if (mapController.currentAddress.value.isNotEmpty &&
            mapController.currentAddress.value != 'Location not found') {
          displayAddress = mapController.currentAddress.value;
        } else if (userData?['address'] != null &&
            userData!['address'].toString().isNotEmpty) {
          // Fallback to profile address if GPS fails/loading
          displayAddress = userData['address'];
        }

        // Local helper for greeting
        String getGreeting() {
          var hour = DateTime.now().hour;
          if (hour < 12) {
            return l10n.greetingMorning;
          }
          if (hour < 17) {
            return l10n.greetingAfternoon;
          }
          return l10n.greetingEvening;
        }

        return sliderController.isLoading.value ||
                tailorController.isLoading.value
            ? const SafeArea(child: HomeLoadingSkeleton())
            : SafeArea(
                child: RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: AppColors.primary,
                  onRefresh: () async {
                    await Future.wait([
                      profileController.getUserProfile(),
                      sliderController.getSliders(),
                      tailorController.getAllTailors(),
                    ]);
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    children: [
                      // 1. Header Section — clean flat
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.15),
                                width: 1.5,
                              ),
                            ),
                            child: ClipOval(
                              child:
                                  (avatarUrl != null &&
                                      avatarUrl.toString().isNotEmpty)
                                  ? Image.network(
                                      avatarUrl.toString().startsWith('http')
                                          ? avatarUrl
                                          : '${apiService.baseUrl}$avatarUrl',
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const Icon(
                                            Icons.person,
                                            color: Colors.grey,
                                          ),
                                    )
                                  : Container(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.08,
                                      ),
                                      child: const Icon(
                                        Icons.person,
                                        color: AppColors.primary,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  getGreeting(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  username,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(
                                      Iconsax.location5,
                                      size: 12,
                                      color: AppColors.secondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        displayAddress,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.1),
                              ),
                            ),
                            child: const Icon(
                              Iconsax.notification,
                              size: 20,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // 2. Search Bar
                      GestureDetector(
                        onTap: () => Get.to(() => const SearchScreen()),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.secondary.withValues(alpha: 0.12)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Iconsax.search_normal,
                                size: 20,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  l10n.searchHint,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Iconsax.filter,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 3. Banner Slider
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 160,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 4),
                          enlargeCenterPage: true,
                          viewportFraction: 0.92,
                          disableCenter: true,
                        ),
                        items: sliderController.sliders
                            .map((slider) => SliderCard(data: slider))
                            .toList(),
                      ),
                      const SizedBox(height: 24),

                      // 4. Categories Grid
                      _buildSectionHeader(
                        l10n.categories,
                        () => Get.to(() => const AllCategoriesScreen()),
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.62,
                            ),
                        itemCount: categoryData.length > 4 ? 4 : categoryData.length,
                        itemBuilder: (context, index) {
                          final category = categoryData[index];
                          return GestureDetector(
                            onTap: () => Get.to(
                              () => SearchScreen(initialCategory: category['name']),
                            ),
                            child: CategoryHori(
                              category: {
                                'name': category['name'] ?? 'Unknown',
                                'iconUrl': category['iconUrl'] ?? '',
                                'color': category['color'] ?? Colors.grey,
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // 5. Closest Tailors
                      _buildSectionHeader(l10n.closestToYou, null),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 140, // Height for TailorCard
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: tailorController.tailors
                              .where((t) => t.distance < 1.0 && _hasAddress(t))
                              .length,
                          itemBuilder: (context, index) {
                            final nearbyTailors = tailorController.tailors
                                .where((t) => t.distance < 1.0 && _hasAddress(t))
                                .toList();

                            return TailorCard(data: nearbyTailors[index]);
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 6. Popular Tailors
                      _buildSectionHeader(l10n.popularTailors, null),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 140,
                        child: Obx(
                          () {
                            final popular = tailorController.popularTailors
                                .where(_hasAddress)
                                .toList();
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: popular.length,
                              itemBuilder: (context, index) {
                                return TailorCard(data: popular[index]);
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 7. Promo Banner Middle
                      Container(
                        width: double.infinity,
                        height: 120, // Constrain height
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            ImageString.banner3,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 8. Recommended
                      _buildSectionHeader(l10n.recommended, null),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: tailorController.tailors
                            .where(_hasAddress)
                            .length,
                        itemBuilder: (context, index) {
                          // TODO: Switch to Vertical variation if needed,
                          // but reuse TailorCard which is styled nicely.
                          // Just verify margin bottom.
                          final recommendedTailors = tailorController.tailors
                              .where(_hasAddress)
                              .toList();
                          return TailorCard(data: recommendedTailors[index]);
                        },
                      ),
                      const SizedBox(height: 80), // Bottom padding
                    ],
                  ),
                ),
              );
        }),
      ),
    );
  }

  /// Tailors without a usable address are hidden from home lists.
  /// The API falls back to 'No Address' when the address is missing.
  bool _hasAddress(Tailor t) {
    final address = t.address.trim();
    return address.isNotEmpty && address != 'No Address';
  }

  Widget _buildSectionHeader(String title, VoidCallback? onTap) {
    return Builder(
      builder: (context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (onTap != null)
            GestureDetector(
              onTap: onTap,
              child: Text(
                AppLocalizations.of(context).seeAll,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
