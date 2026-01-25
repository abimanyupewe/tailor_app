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
import 'package:tailor_app/widgets/tailor_card.dart';
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
      backgroundColor: Colors.grey[50],
      body: Obx(() {
        final userData = profileController.user.value;
        final userObj = userData?['user'];
        final avatarUrl = userObj?['avatar'];
        final username = userObj?['username'] ?? 'User';

        // Priority: 1. Realtime GPS Address (Home should reflect current loc), 2. Fallback
        String displayAddress = 'Finding location...';

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
            return 'Good Morning';
          }
          if (hour < 17) {
            return 'Good Afternoon';
          }
          return 'Good Evening';
        }

        return sliderController.isLoading.value ||
                tailorController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
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
                      // 1. Header Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child:
                                        (avatarUrl != null &&
                                            avatarUrl.toString().isNotEmpty)
                                        ? Image.network(
                                            avatarUrl.toString().startsWith(
                                                  'http',
                                                )
                                                ? avatarUrl
                                                : '${apiService.baseUrl}$avatarUrl',
                                            fit: BoxFit.cover,
                                          )
                                        : const Icon(
                                            Icons.person,
                                            color: Colors.grey,
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: '${getGreeting()}, ',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: username,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          const Icon(
                                            Iconsax.location5,
                                            size: 14,
                                            color: AppColors.primary,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              displayAddress,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
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
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(Iconsax.notification, size: 20),
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
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Iconsax.search_normal,
                                size: 20,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  "Find your perfect tailor...",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
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
                        itemCount: categoryData.length > 3
                            ? 4
                            : categoryData.length,
                        itemBuilder: (context, index) {
                          if (index < 3) {
                            final category = categoryData[index];
                            return GestureDetector(
                              onTap: () => Get.to(
                                () => SearchScreen(
                                  initialCategory: category['name'],
                                ),
                              ),
                              child: CategoryHori(
                                category: {
                                  'name': category['name'] ?? 'Unknown',
                                  'iconUrl': category['iconUrl'] ?? '',
                                  'color': category['color'] ?? Colors.grey,
                                },
                              ),
                            );
                          } else {
                            // "See All" button
                            return GestureDetector(
                              onTap: () =>
                                  Get.to(() => const AllCategoriesScreen()),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.grey.shade100,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.03),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Iconsax.category,
                                      size: 24,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "See All",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 24),

                      // 5. Closest Tailors
                      _buildSectionHeader("Closest to you", () {}),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 140, // Height for TailorCard
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: tailorController.tailors
                              .where((t) => t.distance < 5.0)
                              .length,
                          itemBuilder: (context, index) {
                            final nearbyTailors = tailorController.tailors
                                .where((t) => t.distance < 5.0)
                                .toList();

                            return TailorCard(data: nearbyTailors[index]);
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 6. Popular Tailors
                      _buildSectionHeader("Popular Tailors", () {}),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 140,
                        child: Obx(
                          () => ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: tailorController.popularTailors.length,
                            itemBuilder: (context, index) {
                              return TailorCard(
                                data: tailorController.popularTailors[index],
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 7. Promo Banner Middle
                      Container(
                        width: double.infinity,
                        height: 120, // Constrain height
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
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
                      _buildSectionHeader("Recommended", () {}),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: tailorController.tailors.length,
                        itemBuilder: (context, index) {
                          // TODO: Switch to Vertical variation if needed,
                          // but reuse TailorCard which is styled nicely.
                          // Just verify margin bottom.
                          final recommendedTailors = tailorController.tailors;
                          return TailorCard(data: recommendedTailors[index]);
                        },
                      ),
                      const SizedBox(height: 80), // Bottom padding
                    ],
                  ),
                ),
              );
      }),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: onTap,
          child: const Text(
            "See All",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
