import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/data/api_service.dart';
import 'package:tailor_app/models/tailor_model.dart';
import 'package:tailor_app/screens/tailor/widgets/review_dialog.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
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
        return Image.network(
          Get.find<ApiService>().getImageUrl(post.image),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey.shade200,
            child: const Icon(Icons.error, color: Colors.grey),
          ),
        );
      },
    );
  }
}

class ReviewTab extends StatelessWidget {
  final Tailor tailor;
  const ReviewTab({super.key, required this.tailor});

  Future<void> _handleWriteReview(BuildContext context) async {
    final apiService = Get.find<ApiService>();
    try {
      // 1. Fetch my orders
      final response = await apiService.getOrders();
      // Assuming response is List or Map with results.
      // ApiService.getOrders returns _handleResponse which usually returns List<dynamic> for list endpoints or Map if paginated.
      // Given ApiService structure, getOrders returns direct JSON.
      // Let's assume it returns a list of orders.
      List<dynamic> orders = [];
      if (response is List) {
        orders = response;
      } else if (response is Map && response.containsKey('results')) {
        orders = response['results'];
      }
      // Criteria: tailor.id match, status COMPLETED, has_review == false
      final eligibleOrder = orders.firstWhereOrNull((order) {
        // Handle both int and string IDs safely
        final orderTailorId = order['tailor'] is Map
            ? order['tailor']['id'].toString()
            : order['tailor'].toString();
        final currentTailorId = tailor.id.toString();

        return orderTailorId == currentTailorId &&
            order['status'] == 'COMPLETED' &&
            order['has_review'] == false;
      });

      if (eligibleOrder != null) {
        // 3. Show Dialog
        final result = await Get.dialog(
          ReviewDialog(orderId: eligibleOrder['id']),
        );

        if (result == true) {
          // Refresh tailor details to show new review
          // Ideally we should call a method in TailorController to reload current tailor
          // For now we can trigger a rebuild or reload if possible.
          // Simple way: Get.find<TailorController>().loadInitial(); (might be too broad)
          // Or just let user know.
        }
      } else {
        Get.snackbar(
          "Cannot Write Review",
          "You must have a completed order with this tailor that hasn't been reviewed yet.",
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.orange.shade900,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to check orders: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: () => _handleWriteReview(context),
            icon: const Icon(Iconsax.edit, size: 18),
            label: const Text("Write a Review"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              elevation: 0,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 16),
          if (tailor.reviews.isEmpty)
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
              itemCount: tailor.reviews.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final review = tailor.reviews[index];
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
