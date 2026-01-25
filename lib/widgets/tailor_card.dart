import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailor_app/models/tailor_model.dart';
import 'package:tailor_app/screens/tailor/tailor_detail_screen.dart';
import 'package:tailor_app/data/api_service.dart';
import 'package:tailor_app/core/constants/app_colors.dart';

class TailorCard extends StatelessWidget {
  final Tailor data;
  const TailorCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => TailorDetailScreen(tailor: data));
      },
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 12, bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              // Tailor Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Builder(
                  builder: (context) {
                    final apiService = Get.find<ApiService>();
                    final imageUrl = data.imageUrl;

                    if (imageUrl.isEmpty) {
                      return Container(
                        width: 90,
                        height: 90,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.checkroom,
                          color: Colors.grey,
                          size: 30,
                        ),
                      );
                    }

                    final fullUrl = apiService.getImageUrl(imageUrl);

                    return Image.network(
                      fullUrl,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 90,
                        height: 90,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.broken_image_outlined,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.name,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.address,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        // Rating
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 14,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 3),
                              Builder(
                                builder: (context) {
                                  var rating = data.rating;
                                  var count = data.reviewCount;

                                  // Fallback: If model rating is 0 but we have reviews (from controller update), calculate it
                                  if (rating == 0.0 &&
                                      data.reviews.isNotEmpty) {
                                    count = data.reviews.length;
                                    rating =
                                        data.reviews
                                            .map((r) => r.rating)
                                            .fold(0.0, (a, b) => a + b) /
                                        count;
                                  }

                                  return Text(
                                    "${rating.toStringAsFixed(1)} ($count)",
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber[800],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Distance
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              data.formattedDistance,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
