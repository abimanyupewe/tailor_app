import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/core/constants/image_string.dart';
import 'package:tailor_app/data/dummy_data.dart';
import 'package:tailor_app/controllers/slider_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
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
      body: Obx(() {
        final userData = profileController.user.value;
        final userObj = userData?['user'];
        final avatarUrl = userObj?['avatar'];
        final username = userObj?['username'] ?? 'User';

        // Priority: 1. Profile Address, 2. Realtime GPS Address, 3. Fallback
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

        return sliderController.isLoading.value ||
                tailorController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
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
                  padding: const EdgeInsets.all(20),
                  children: [
                    Wrap(
                      runSpacing: 15,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.grey.shade300,
                                  backgroundImage:
                                      (avatarUrl != null &&
                                          avatarUrl.toString().isNotEmpty)
                                      ? NetworkImage(
                                          avatarUrl.toString().startsWith(
                                                'http',
                                              )
                                              ? avatarUrl
                                              : '${apiService.baseUrl}$avatarUrl',
                                        )
                                      : null,
                                  child:
                                      (avatarUrl == null ||
                                          avatarUrl.toString().isEmpty)
                                      ? const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Hi, ',
                                            style: GoogleFonts.plusJakartaSans(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          TextSpan(
                                            text: username,
                                            style: GoogleFonts.plusJakartaSans(
                                              color: AppColors.primary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Iconsax.location5,
                                          size: 14,
                                          color: AppColors.primary,
                                        ),
                                        const SizedBox(width: 4),
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            displayAddress,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Iconsax.notification),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Get.to(() => const SearchScreen()),
                          child: AbsorbPointer(
                            child: TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                  left: 20,
                                  top: 15,
                                  bottom: 15,
                                ),
                                hintText: "Search for tailors or services",
                                hintStyle: const TextStyle(
                                  color: AppColors.primary,
                                ),
                                suffixIcon: IconButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                          AppColors.primary,
                                        ),
                                  ),
                                  onPressed: () {}, // Empty but required
                                  icon: const Icon(
                                    Iconsax.search_normal,
                                    color: Colors.white,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                            ),
                          ),
                        ),
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 150,
                            autoPlayAnimationDuration: Duration(seconds: 2),
                            autoPlay: true,
                            enlargeCenterPage: true,
                            viewportFraction: 0.9,
                            disableCenter: true,
                          ),
                          items: sliderController.sliders
                              .map((slider) => SliderCard(data: slider))
                              .toList(),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 0.65,
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
                              // Slot ke-4 = "Lihat Semua"
                              return GestureDetector(
                                onTap: () =>
                                    Get.to(() => const AllCategoriesScreen()),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.more_horiz,
                                        size: 28,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      "See All",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),

                        // Terdekat
                        Text(
                          "Closest to you",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 120,
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

                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(ImageString.banner3),
                          ),
                        ),

                        Text(
                          "Popular Tailors",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 120,
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

                        Text(
                          "Recommended Tailors",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: tailorController.tailors.length,
                          itemBuilder: (context, index) {
                            final recommendedTailors = tailorController.tailors;
                            return TailorCard(data: recommendedTailors[index]);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
      }),
    );
  }
}
