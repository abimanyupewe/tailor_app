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
import 'package:tailor_app/l10n/generated/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.background,
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
                        color: Colors.black.withValues(alpha: 0.3),
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
                                  Colors.black.withValues(alpha: 0.3),
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.1),
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
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.10)),
                      ),
                      child: Obx(() {
                        final currentTailor = controller.tailor.value;

                        var rating = currentTailor.rating;
                        var count = currentTailor.reviewCount;
                        if (rating == 0.0 && controller.reviews.isNotEmpty) {
                          count = controller.reviews.length;
                          rating =
                              controller.reviews
                                  .map((r) => r.rating)
                                  .fold(0.0, (a, b) => a + b) /
                              count;
                        }

                        final meta = <String>[
                          rating.toStringAsFixed(1),
                          if (count > 0) '($count)',
                          if (currentTailor.distance > 0)
                            currentTailor.formattedDistance,
                          if (currentTailor.services.isNotEmpty)
                            l10n.servicesCount(currentTailor.services.length),
                        ];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    currentTailor.name,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      height: 1.25,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                if (currentTailor.isVerified)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 6, top: 3),
                                    child: Icon(
                                      Icons.verified,
                                      size: 20,
                                      color: Colors.blue,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    meta.join('  ·  '),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Icon(
                                    Iconsax.location,
                                    size: 15,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    currentTailor.address,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                      height: 1.4,
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
                    TabBar(
                      labelColor: AppColors.primary,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: AppColors.primary,
                      indicatorWeight: 3,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      tabs: [
                        Tab(text: l10n.tabService),
                        Tab(text: l10n.tabPosts),
                        Tab(text: l10n.tabRating),
                        Tab(text: l10n.tabContact),
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
            border: Border(
              top: BorderSide(color: AppColors.secondary.withValues(alpha: 0.12)),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
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
                  height: 54,
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
                    child: Text(
                      l10n.bookNow,
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
    return true;
  }
}
