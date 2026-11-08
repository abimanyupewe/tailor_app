import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_app/models/tailor_model.dart';
import 'package:tailor_app/screens/tailor/tailor_detail_screen.dart';
import 'package:tailor_app/data/api_service.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/l10n/generated/app_localizations.dart';

class TailorCard extends StatelessWidget {
  final Tailor data;
  const TailorCard({super.key, required this.data});

  /// Compact rupiah: 30000 -> "Rp 30rb", 1500000 -> "Rp 1,5jt".
  String _compactPrice(double price) {
    if (price >= 1000000) {
      final v = price / 1000000;
      final str = v % 1 == 0 ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
      return 'Rp ${str.replaceAll('.', ',')}jt';
    }
    if (price >= 1000) {
      final v = price / 1000;
      final str = v % 1 == 0 ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
      return 'Rp ${str.replaceAll('.', ',')}rb';
    }
    return 'Rp ${price.toStringAsFixed(0)}';
  }

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
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.secondary.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            // Tailor Image with distance overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Builder(
                    builder: (context) {
                      final apiService = Get.find<ApiService>();
                      final imageUrl = data.imageUrl;

                      if (imageUrl.isEmpty) {
                        return Container(
                          width: 84,
                          height: 84,
                          color: Colors.grey[100],
                          child: const Icon(
                            Icons.checkroom,
                            color: Colors.grey,
                            size: 26,
                          ),
                        );
                      }

                      final fullUrl = apiService.getImageUrl(imageUrl);

                      return Image.network(
                        fullUrl,
                        width: 84,
                        height: 84,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 84,
                          height: 84,
                          color: Colors.grey[100],
                          child: const Icon(
                            Icons.broken_image_outlined,
                            color: Colors.grey,
                            size: 26,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (data.distance > 0)
                  Positioned(
                    left: 6,
                    bottom: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${data.distance.toStringAsFixed(1)} km',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
              ],
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
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
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

                      final parts = <String>[];
                      if (data.services.isNotEmpty) {
                        parts.add(
                          AppLocalizations.of(
                            context,
                          ).servicesCount(data.services.length),
                        );
                      }

                      return Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              ([
                                '${rating.toStringAsFixed(1)} ($count)',
                                ...parts,
                              ]).join(' • '),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Builder(
                    builder: (context) {
                      if (data.services.isEmpty) return const SizedBox.shrink();
                      final minPrice = data.services
                          .map((s) => s.price)
                          .reduce((a, b) => a < b ? a : b);
                      if (minPrice <= 0) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          '${AppLocalizations.of(context).startingFrom} ${_compactPrice(minPrice)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
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
