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
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              Obx(() {
                final currentTailor = controller.tailor.value;
                final imageUrl = _getValidImageUrl(currentTailor.imageUrl);

                return SliverAppBar(
                  expandedHeight: 250,
                  pinned: true,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                    ),
                    onPressed: () => Get.back(),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: Colors.grey,
                                  child: const Center(child: Icon(Icons.error)),
                                ),
                          )
                        : Container(
                            color: Colors.grey,
                            child: const Center(
                              child: Icon(Icons.image_not_supported),
                            ),
                          ),
                  ),
                );
              }),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Obx(() {
                    final currentTailor = controller.tailor.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                currentTailor.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber),
                                const SizedBox(width: 4),
                                Builder(
                                  builder: (context) {
                                    final reviews = controller.reviews;
                                    final count = reviews.length;
                                    double average = 0.0;
                                    if (count > 0) {
                                      average =
                                          reviews
                                              .map((r) => r.rating)
                                              .reduce((a, b) => a + b) /
                                          count;
                                    }
                                    return Text(
                                      "${average.toStringAsFixed(1)} ($count)",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Iconsax.location,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                currentTailor.address,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
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
