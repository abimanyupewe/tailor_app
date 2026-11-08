import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_app/controllers/service_controller.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/core/utils/app_toast.dart';
import 'package:tailor_app/core/utils/currency.dart';
import 'package:tailor_app/l10n/generated/app_localizations.dart';
import 'package:tailor_app/models/tailor_model.dart';
import 'package:tailor_app/screens/tailor/widgets/service_form_sheet.dart';
import 'package:tailor_app/widgets/skeleton.dart';

class ManageServicesScreen extends StatelessWidget {
  const ManageServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ServiceController());
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.manageServices,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showServiceFormSheet(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Iconsax.add),
        label: Text(l10n.addService),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.services.isEmpty) {
          return const CardListSkeleton(itemCount: 4);
        }
        if (controller.services.isEmpty) {
          return _EmptyState(
            onAdd: () => showServiceFormSheet(context),
          );
        }
        return RefreshIndicator(
          color: Colors.white,
          backgroundColor: AppColors.primary,
          onRefresh: controller.loadServices,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
            itemCount: controller.services.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final service = controller.services[index];
              return _ServiceCard(
                service: service,
                onEdit: () => showServiceFormSheet(context, service: service),
                onDelete: () => _confirmDelete(context, controller, service),
              );
            },
          ),
        );
      }),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ServiceController controller,
    Service service,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(l10n.deleteService),
        content: Text(l10n.confirmDeleteService(service.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              l10n.deleteAction,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    final error = await controller.remove(service);
    if (error == null) {
      AppToast.success(l10n.serviceDeleted);
    } else {
      AppToast.error(error);
    }
  }
}

class _ServiceCard extends StatelessWidget {
  final Service service;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ServiceCard({
    required this.service,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final description = service.description.trim();

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Iconsax.scissor,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        service.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (!service.isActive) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          l10n.serviceInactive,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      height: 1.4,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 4,
                  children: [
                    Text(
                      formatRupiah(service.price),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    if (service.estimatedDurationDays > 0)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.clock,
                            size: 13,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.serviceDurationValue(
                              service.estimatedDurationDays,
                            ),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Iconsax.more, size: 18, color: Colors.grey.shade500),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              if (value == 'edit') onEdit();
              if (value == 'delete') onDelete();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    const Icon(Iconsax.edit_2, size: 18),
                    const SizedBox(width: 10),
                    Text(l10n.editAction),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Iconsax.trash, size: 18, color: Colors.red),
                    const SizedBox(width: 10),
                    Text(
                      l10n.deleteAction,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.document_text,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noTailorServices,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Iconsax.add, color: Colors.white, size: 18),
              label: Text(l10n.addService),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
