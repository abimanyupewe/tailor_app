import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/core/constants/app_data.dart';
import 'package:tailor_app/screens/search/search_screen.dart';
import 'package:tailor_app/widgets/category_hori.dart'; // Reusing or creating new item widget if needed

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine source of data. Assuming DataCategory().data works as per Home
    final categoryData = AppData.categories;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "All Categories",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.7,
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
                    width: 60,
                    height: 60,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (category['color'] as Color? ?? AppColors.primary)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
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
                      color: Colors.black87,
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
