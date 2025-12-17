import 'package:flutter/material.dart';
import 'package:tailor_app/widgets/category_hori.dart';

class AllCategoryPage extends StatelessWidget {
  final List<Map<String, String>> categoryData;
  const AllCategoryPage({super.key, required this.categoryData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Semua Kategori")),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: categoryData.length,
        itemBuilder: (context, index) {
          final category = categoryData[index];
          return CategoryHori(category: category);
        },
      ),
    );
  }
}
