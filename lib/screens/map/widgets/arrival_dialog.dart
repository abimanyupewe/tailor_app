import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/l10n/generated/app_localizations.dart';

class ArrivalDialog extends StatelessWidget {
  final String tailorName;
  final VoidCallback onReview;

  const ArrivalDialog({
    super.key,
    required this.tailorName,
    required this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.location_tick5,
                color: Colors.green,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.arrivedTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.arrivedBody(tailorName),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back(); // Close dialog
                  onReview(); // Callback to open reviews
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  l10n.giveRating,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                l10n.close,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
