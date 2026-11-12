import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/core/constants/app_data.dart';
import 'package:tailor_app/l10n/generated/app_localizations.dart';
import 'package:tailor_app/screens/search/search_screen.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine source of data. Assuming DataCategory().data works as per Home
    final categoryData = AppData.categories;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).allCategories,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 14,
            childAspectRatio: 0.86,
          ),
          itemCount: categoryData.length,
          itemBuilder: (context, index) {
            final category = categoryData[index];
            return GestureDetector(
              onTap: () {
                // Navigate to Search with Filter
                Get.to(() => SearchScreen(initialCategory: category['name']));
              },
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 86,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (category['color'] as Color? ?? AppColors.primary)
                          .withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.secondary.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Image.asset(
                      category['iconUrl'], // Assuming asset based on CategoryHori
                      color: category['color'] as Color? ?? AppColors.primary,
                      errorBuilder: (ctx, err, stack) =>
                          Icon(Icons.category, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category['name'],
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
