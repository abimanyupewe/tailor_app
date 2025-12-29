import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_app/controllers/order_controller.dart';
import 'package:tailor_app/models/tailor_model.dart';

class OrderScreen extends StatelessWidget {
  final Tailor tailor;
  const OrderScreen({super.key, required this.tailor});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController(tailor));

    return Scaffold(
      appBar: AppBar(
        title: Text("Order from ${tailor.name}"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.items.isEmpty) {
                return const Center(child: Text("No services available"));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.items.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final item = controller.items[index];
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.service.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "Rp ${item.service.price.toStringAsFixed(0)}",
                                  style: const TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                          // Quantity Controls
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => controller.decrement(item),
                                icon: const Icon(Icons.remove_circle_outline),
                                color: Colors.grey,
                              ),
                              Obx(
                                () => Text(
                                  "${item.quantity.value}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => controller.increment(item),
                                icon: const Icon(Icons.add_circle_outline),
                                color: Colors.deepPurple,
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Notes field (visible if quantity > 0)
                      Obx(() {
                        if (item.quantity.value > 0) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: "Notes (e.g. Size L, color red)",
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.all(8),
                              ),
                              onChanged: (val) => item.notes.value = val,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  );
                },
              );
            }),
          ),
          // Bottom Bar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Obx(
                        () => Text(
                          "Rp ${controller.totalPrice.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Obx(() {
                      final count = controller.totalItems;
                      return ElevatedButton(
                        onPressed: controller.isLoading.value || count == 0
                            ? null
                            : () => controller.createOrder(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Checkout ($count items)",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
