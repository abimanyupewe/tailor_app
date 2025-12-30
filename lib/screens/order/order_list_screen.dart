import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_app/data/api_service.dart';
import 'package:tailor_app/models/order_model.dart';
import 'package:tailor_app/screens/order/widgets/order_card.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = Get.find<ApiService>();

    return Scaffold(
      backgroundColor:
          Colors.grey[50], // Light background for better card contrast
      appBar: AppBar(
        title: const Text(
          "My Orders",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: apiService.getOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          List<Order> orders = [];

          try {
            if (snapshot.data is Map) {
              final results =
                  (snapshot.data as Map)['results'] as List<dynamic>? ?? [];
              orders = results
                  .map((json) => Order.fromJson(json as Map<String, dynamic>))
                  .toList();
            } else if (snapshot.data is List) {
              orders = (snapshot.data as List)
                  .map((json) => Order.fromJson(json as Map<String, dynamic>))
                  .toList();
            }
          } catch (e) {
            print("Error parsing orders: $e");
            return Center(child: Text("Error parsing data: $e"));
          }

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No orders yet",
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: orders.length,
            padding: const EdgeInsets.all(20),
            itemBuilder: (context, index) {
              return OrderCard(order: orders[index]);
            },
          );
        },
      ),
    );
  }
}
