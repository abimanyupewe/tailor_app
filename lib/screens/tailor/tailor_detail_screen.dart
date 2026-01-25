import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_app/models/tailor_model.dart';
import 'package:tailor_app/data/api_service.dart';
import 'package:tailor_app/controllers/chat_controller.dart';
import 'package:tailor_app/screens/order/order_screen.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/screens/tailor/widgets/tailor_tabs.dart';
import 'package:tailor_app/controllers/tailor_detail_controller.dart';

class TailorDetailScreen extends StatelessWidget {
  final Tailor tailor;
  const TailorDetailScreen({super.key, required this.tailor});

  String _getValidImageUrl(String? url) {
    final fullUrl = Get.find<ApiService>().getImageUrl(url);
    if (fullUrl.isEmpty) return '';
    try {
      final uri = Uri.parse(fullUrl);
      if (uri.scheme != 'http' && uri.scheme != 'https') {
        return '';
      }
    } catch (_) {
      return '';
    }
    return fullUrl;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TailorDetailController(tailor), tag: tailor.id);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.grey[50], // Premium off-white background
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.refreshTailor();
          },
          color: Colors.white,
          backgroundColor: AppColors.primary,
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                Obx(() {
                  final currentTailor = controller.tailor.value;
                  final imageUrl = _getValidImageUrl(currentTailor.imageUrl);

                  return SliverAppBar(
                    expandedHeight: 300,
                    pinned: true,
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    leading: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => Get.back(),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(color: Colors.grey.shade300),
                                )
                              : Container(color: Colors.grey.shade300),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.1),
                                ],
                                stops: const [0.0, 0.4, 1.0],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Obx(() {
                        final currentTailor = controller.tailor.value;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    currentTailor.name,
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800,
                                      height: 1.2,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.star_rounded,
                                        color: Colors.amber,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Builder(
                                        builder: (context) {
                                          var rating = currentTailor.rating;
                                          var count = currentTailor.reviewCount;

                                          // Fallback: If model rating is 0 but we have reviews in controller, calculate it
                                          if (rating == 0.0 &&
                                              controller.reviews.isNotEmpty) {
                                            count = controller.reviews.length;
                                            rating =
                                                controller.reviews
                                                    .map((r) => r.rating)
                                                    .fold(
                                                      0.0,
                                                      (a, b) => a + b,
                                                    ) /
                                                count;
                                          }

                                          return Text(
                                            "${rating.toStringAsFixed(1)} ($count)",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.amber[900],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(
                                  Iconsax.location,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    currentTailor.address,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                // Open/Close Badge (Mockup)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    "Open Now",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Distance Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "${currentTailor.distance.toStringAsFixed(1)} km away",
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    const TabBar(
                      labelColor: AppColors.primary,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: AppColors.primary,
                      indicatorWeight: 3,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      tabs: [
                        Tab(text: "Service"),
                        Tab(text: "Post"),
                        Tab(text: "Rating"),
                        Tab(text: "Contact"),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: Obx(() {
              final currentTailor = controller.tailor.value;
              return TabBarView(
                children: [
                  ServiceTab(tailor: currentTailor),
                  PostTab(tailor: currentTailor),
                  ReviewTab(
                    tailor: currentTailor,
                    reviews: controller.reviews,
                    onReviewSuccess: () => controller.refreshTailor(),
                  ),
                  ContactTab(tailor: currentTailor),
                ],
              );
            }),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    final chatController = Get.put(ChatController());
                    final targetId =
                        (tailor.userId != null && tailor.userId!.isNotEmpty)
                        ? tailor.userId!
                        : tailor.id;
                    chatController.startChatWithTailor(targetId);
                  },
                  icon: const Icon(Iconsax.message, color: AppColors.primary),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => OrderScreen(tailor: tailor));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Book Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
