import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        margin: const EdgeInsets.only(right: 16, bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Tailor Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Builder(
                builder: (context) {
                  final apiService = Get.find<ApiService>();
                  final imageUrl = data.imageUrl;

                  if (imageUrl.isEmpty) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[100],
                      child: const Icon(
                        Icons.checkroom,
                        color: Colors.grey,
                        size: 24,
                      ),
                    );
                  }

                  final fullUrl = apiService.getImageUrl(imageUrl);

                  return Image.network(
                    fullUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[100],
                      child: const Icon(
                        Icons.broken_image_outlined,
                        color: Colors.grey,
                        size: 24,
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
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 12,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          data.address,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Rating
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Builder(
                              builder: (context) {
                                var rating = data.rating;
                                var count = data.reviewCount;

                                // Fallback calculation
                                if (rating == 0.0 && data.reviews.isNotEmpty) {
                                  count = data.reviews.length;
                                  rating =
                                      data.reviews
                                          .map((r) => r.rating)
                                          .fold(0.0, (a, b) => a + b) /
                                      count;
                                }

                                return Text(
                                  "${rating.toStringAsFixed(1)} ($count)",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber[900],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Distance
                      if (data.distance > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${data.distance.toStringAsFixed(1)} km",
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
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
    );
  }
}
