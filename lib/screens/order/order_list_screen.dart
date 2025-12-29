import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_app/data/api_service.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = Get.find<ApiService>();

    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),
      body: FutureBuilder(
        future: apiService.getOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          List<dynamic> orders = [];
          if (snapshot.data is Map) {
            orders = (snapshot.data as Map)['results'] ?? [];
          } else if (snapshot.data is List) {
            orders = snapshot.data as List;
          }

          if (orders.isEmpty) {
            return const Center(child: Text("No orders yet"));
          }

          return ListView.builder(
            itemCount: orders.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final order = orders[index];
              final items = order['items'] as List<dynamic>? ?? [];
              final totalPrice = order['total_price'] ?? '0';
              final status = order['status'] ?? 'UNKNOWN';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text("Order #${order['id']}"),
                  subtitle: Text("${items.length} items • $status"),
                  trailing: Text(
                    "Rp $totalPrice",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
