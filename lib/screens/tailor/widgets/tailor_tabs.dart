import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/data/api_service.dart';
import 'package:tailor_app/models/tailor_model.dart';
import 'package:tailor_app/screens/tailor/widgets/review_dialog.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:tailor_app/screens/post/post_detail_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceTab extends StatelessWidget {
  final Tailor tailor;
  const ServiceTab({super.key, required this.tailor});

  @override
  Widget build(BuildContext context) {
    if (tailor.services.isEmpty) {
      return const Center(child: Text("No services available"));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: tailor.services.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final service = tailor.services[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              service.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              service.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            trailing: Text(
              'Rp ${service.price.toStringAsFixed(0)}',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }
}

class PostTab extends StatelessWidget {
  final Tailor tailor;
  const PostTab({super.key, required this.tailor});

  @override
  Widget build(BuildContext context) {
    if (tailor.posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.gallery_slash, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text("No posts yet", style: TextStyle(color: Colors.grey.shade500)),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: tailor.posts.length,
      itemBuilder: (context, index) {
        final post = tailor.posts[index];
        final imageUrl = Get.find<ApiService>().getImageUrl(post.image);
        // Basic validation
        bool isValidUrl =
            imageUrl.isNotEmpty &&
            (imageUrl.startsWith('http') || imageUrl.startsWith('https'));

        return GestureDetector(
          onTap: () {
            Get.to(
              () => PostDetailScreen(
                post: post,
                tailorName: tailor.name,
                tailorImage: tailor.imageUrl,
              ),
            );
          },
          child: isValidUrl
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.error, color: Colors.grey),
                  ),
                )
              : Container(
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
                ),
        );
      },
    );
  }
}

class ReviewTab extends StatelessWidget {
  final Tailor tailor;
  final List<Review>? reviews;
  final VoidCallback? onReviewSuccess;

  const ReviewTab({
    super.key,
    required this.tailor,
    this.reviews,
    this.onReviewSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final reviewList = reviews ?? tailor.reviews;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (reviewList.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.message_text,
                      size: 48,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No reviews yet",
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviewList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final review = reviewList[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            review.userName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                review.rating.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        review.comment,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${review.date.day}/${review.date.month}/${review.date.year}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class ContactTab extends StatelessWidget {
  final Tailor tailor;
  const ContactTab({super.key, required this.tailor});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (!await launchUrl(launchUri)) {
      Get.snackbar('Error', 'Could not launch $launchUri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Address Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Address",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Iconsax.location,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tailor.address,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(
                          tailor.latitude,
                          tailor.longitude,
                        ),
                        initialZoom: 15.0,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.none,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.tailor_app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(tailor.latitude, tailor.longitude),
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Contact Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _makePhoneCall(tailor.phoneNumber),
              icon: const Icon(Iconsax.call),
              label: Text("Call ${tailor.phoneNumber}"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
