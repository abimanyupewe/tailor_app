import 'package:flutter/material.dart';

class CategoryHori extends StatelessWidget {
  const CategoryHori({super.key, required this.category});
  final Map<String, dynamic> category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Aksi saat kategori ditekan
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              // color: category['color'] ?? Colors.grey[200],
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Image.asset(
                category['iconUrl']!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 80,
            child: Text(
              category['name']!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
