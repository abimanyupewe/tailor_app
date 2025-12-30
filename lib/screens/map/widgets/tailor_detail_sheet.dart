import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_app/controllers/map_controller.dart';
import 'package:tailor_app/data/api_service.dart' as tailor_app;
import 'package:tailor_app/models/tailor_model.dart';
import 'package:tailor_app/screens/tailor/tailor_detail_screen.dart';

class TailorDetailSheet extends StatelessWidget {
  final Tailor selected;

  const TailorDetailSheet({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    final mapController = Get.find<MapControllerX>();

    return DraggableScrollableSheet(
      key: const ValueKey('detail_sheet'),
      initialChildSize: 0.3,
      minChildSize: 0.25,
      maxChildSize: 0.3,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    // --- Header Card (Clickable) ---
                    InkWell(
                      onTap: () {
                        Get.to(() => TailorDetailScreen(tailor: selected));
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: _buildHeaderCard(context),
                    ),
                    const SizedBox(height: 20),

                    // --- Route Button (Wide) ---
                    _buildRouteButton(mapController),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRouteButton(MapControllerX controller) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Obx(() {
        final isRouting = controller.isRoutingMode.value;
        return ElevatedButton.icon(
          onPressed: () {
            controller.toggleRouting();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isRouting ? Colors.red : Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 0,
          ),
          icon: Icon(
            isRouting ? Iconsax.close_circle : Iconsax.direct_right,
            color: Colors.white,
          ),
          label: Text(
            isRouting ? "Stop Routing" : "Lihat Rute",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              Get.find<tailor_app.ApiService>().getImageUrl(selected.imageUrl),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 80,
                height: 80,
                color: Colors.grey[200],
                child: const Icon(Icons.store, size: 30),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Tailor Service",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  selected.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Rp 50k", // Placeholder
                        style: TextStyle(
                          color: Colors.red[400],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      selected.rating.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
