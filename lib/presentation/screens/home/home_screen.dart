import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/core/constants/image_string.dart';
import 'package:tailor_app/data/dataDummy.dart';
import 'package:tailor_app/presentation/controllers/slider_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_app/presentation/controllers/tailor_controller.dart';
import 'package:tailor_app/presentation/widgets/category_hori.dart';
import 'package:tailor_app/presentation/widgets/sliderCard.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tailor_app/presentation/widgets/tailorCard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sliderController = Get.find<SliderController>();
    final tailorController = Get.find<TailorController>();
    final categoryData = DataCategory().data;

    return Scaffold(
      body: Obx(
        () =>
            sliderController.isLoading.value || tailorController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
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
                                  backgroundImage: NetworkImage(
                                    'https://randomuser.me/api/portraits/men/1.jpg',
                                  ),
                                ),
                                SizedBox(width: 15),
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
                                            text: 'John Doe',
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
                                        Icon(
                                          Iconsax.location5,
                                          size: 14,
                                          color: AppColors.primary,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Soekarno hatta street',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
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
                        TextField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                              left: 20,
                              top: 15,
                              bottom: 15,
                            ),
                            hintText: "Search for tailors or services",
                            hintStyle: TextStyle(color: AppColors.primary),
                            suffixIcon: IconButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                  AppColors.primary,
                                ),
                              ),
                              onPressed: () {
                                print("Tertap search");
                              },
                              icon: Icon(
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
                              return CategoryHori(
                                category: {
                                  'name': category['name'] ?? 'Unknown',
                                  'iconUrl': category['iconUrl'] ?? '',
                                  'color': category['color'] ?? Colors.grey,
                                },
                              );
                            } else {
                              // Slot ke-4 = "Lihat Semua"
                              return GestureDetector(
                                onTap: () {},
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
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            itemCount: tailorController.tailors
                                .where((t) => t.reviewCount > 50)
                                .length,
                            itemBuilder: (context, index) {
                              final popularTailors = tailorController.tailors
                                  .where((t) => t.reviewCount > 50)
                                  .toList();
                              return TailorCard(data: popularTailors[index]);
                            },
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
              ),
      ),
    );
  }
}
