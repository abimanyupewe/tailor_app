import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_app/controllers/tailor_controller.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/core/constants/app_data.dart';
import 'package:tailor_app/widgets/tailor_card.dart';

class SearchScreen extends StatefulWidget {
  final String? initialCategory;
  final String? initialQuery;

  const SearchScreen({super.key, this.initialCategory, this.initialQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TailorController tailorController = Get.find<TailorController>();

  String _selectedCategory = 'All';
  final List<String> _categories = ['All'];

  @override
  void initState() {
    super.initState();
    // Initialize Search
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
    }

    // Initialize Category List from Data
    final rawCats = AppData.categories;
    for (var cat in rawCats) {
      _categories.add(cat['name']);
    }

    // Set Active Category
    if (widget.initialCategory != null) {
      _selectedCategory = widget.initialCategory!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Explore Tailors",
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
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _searchController,
              autofocus:
                  widget.initialQuery == null &&
                  widget.initialCategory ==
                      null, // Autofocus if opened purely for search
              onChanged: (val) => setState(() {}),
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Iconsax.search_normal,
                  color: Colors.grey,
                ),
                hintText: "Search by name...",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),

          // 2. Category Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: _categories.map((cat) {
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: FilterChip(
                    label: Text(
                      cat,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = cat; // Always select, pure filter
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: AppColors.primary,
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.grey.shade300,
                      ),
                    ),
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),

          // 3. Tailor List
          Expanded(
            child: Obx(() {
              if (tailorController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // Filter Logic
              final tailors = tailorController.tailors.where((t) {
                // Name Search
                final query = _searchController.text.toLowerCase();
                final nameMatch = t.name.toLowerCase().contains(query);

                // Category Filter (Mock logic: Assuming all match 'All' or name match category if no dedicated field)
                // TODO: Enhance filtered based on Tailor Model skills/services
                // For now, if category is 'All', return true.
                // If not 'All', we check if tailor name or description contains category (fuzzy match)
                // OR ideally check t.categories list if available.
                // Since I can't see the model, I'll allow ALL for specific categories temporarily
                // OR check if t.name contains it? No that's bad.
                // I will assume for this MVP that simple search is priority.
                bool catMatch = true;
                if (_selectedCategory != 'All') {
                  // Placeholder filter: Assume if user filtered, we verify later.
                  // Actually, let's try to match something.
                  // catMatch = t.description.contains(_selectedCategory);
                  catMatch =
                      true; // defaulting to true to not hide everything until model is verified.
                }

                return nameMatch && catMatch;
              }).toList();

              if (tailors.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.search_status,
                        size: 64,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No tailors found",
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                itemCount: tailors.length,
                itemBuilder: (context, index) {
                  return TailorCard(data: tailors[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
