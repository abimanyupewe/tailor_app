import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/data/api_service.dart';
import 'package:tailor_app/models/tailor_model.dart';
import 'package:iconsax/iconsax.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;
  final String tailorName;
  final String? tailorImage;

  const PostDetailScreen({
    super.key,
    required this.post,
    required this.tailorName,
    this.tailorImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              InteractiveViewer(
                child: Image.network(
                  Get.find<ApiService>().getImageUrl(post.image),
                  fit: BoxFit.contain,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 300,
                    color: Colors.grey.shade900,
                    child: const Center(
                      child: Icon(Icons.error, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tailor Info
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: tailorImage != null
                              ? NetworkImage(
                                  Get.find<ApiService>().getImageUrl(
                                    tailorImage!,
                                  ),
                                )
                              : null,
                          backgroundColor: Colors.grey.shade800,
                          child: tailorImage == null
                              ? const Icon(Icons.person, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          tailorName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Caption
                    if (post.caption.isNotEmpty)
                      Text(
                        post.caption,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
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
