import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_app/controllers/map_controller.dart';
import 'package:tailor_app/controllers/tailor_controller.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/data/api_service.dart' as tailor_app;
import 'package:tailor_app/models/tailor_model.dart';
import 'package:tailor_app/widgets/skeleton.dart';
import 'package:tailor_app/l10n/generated/app_localizations.dart';

class TailorListSheet extends StatelessWidget {
  final bool fullScreen;

  const TailorListSheet({super.key, this.fullScreen = false});

  @override
  Widget build(BuildContext context) {
    final mapController = Get.find<MapControllerX>();
    final tailorController = Get.find<TailorController>();
    final l10n = AppLocalizations.of(context);

    if (fullScreen) {
      return _buildContent(context, mapController, tailorController, l10n, null);
    }

    return DraggableScrollableSheet(
      key: const ValueKey('list_sheet'),
      initialChildSize: 0.3,
      minChildSize: 0.1,
      maxChildSize: 1.0,
      snap: true,
      builder: (context, scrollController) => _buildContent(
        context,
        mapController,
        tailorController,
        l10n,
        scrollController,
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    MapControllerX mapController,
    TailorController tailorController,
    AppLocalizations l10n,
    ScrollController? scrollController,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: fullScreen
            ? BorderRadius.zero
            : const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        children: [
          if (!fullScreen) ...[
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.nearbyTailors,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Obx(() {
                  final count = mapController.nearbyTailors.length;
                  if (count == 0) return const SizedBox.shrink();
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Obx(() {
              if (tailorController.isLoading.value &&
                  tailorController.tailors.isEmpty) {
                return const CardListSkeleton(itemCount: 3);
              }
              final tailors = mapController.nearbyTailors;
              if (tailors.isEmpty) return _EmptyTailors(l10n: l10n);
              return ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: tailors.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final tailor = tailors[index];
                  return _TailorListItem(
                    tailor: tailor,
                        onTap: () {
                          mapController.selectTailor(tailor);
                          if (fullScreen) {
                            DefaultTabController.of(context).animateTo(0);
                          }
                        },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _TailorListItem extends StatelessWidget {
  final Tailor tailor;
  final VoidCallback onTap;

  const _TailorListItem({required this.tailor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.12)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    Get.find<tailor_app.ApiService>().getImageUrl(
                      tailor.imageUrl,
                    ),
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 64,
                      height: 64,
                      color: Colors.grey[200],
                      child: Icon(Iconsax.shop, color: Colors.grey.shade400),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tailor.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${tailor.rating} • ${tailor.formattedDistance}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tailor.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyTailors extends StatelessWidget {
  final AppLocalizations l10n;

  const _EmptyTailors({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Iconsax.location,
                      size: 30,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.noTailorsFound,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
