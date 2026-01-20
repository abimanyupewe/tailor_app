import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_app/data/api_service.dart';
import 'package:tailor_app/models/order_model.dart';
import 'package:tailor_app/screens/order/order_detail_screen.dart';
import 'package:tailor_app/screens/order/widgets/order_card.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  late Future<dynamic> _ordersFuture;
  final apiService = Get.find<ApiService>();

  @override
  void initState() {
    super.initState();
    _ordersFuture = apiService.getOrders();
  }

  Future<void> _refreshOrders() async {
    final newFuture = apiService.getOrders();
    // Wait for it to finish so RefreshIndicator spinner spins correctly
    await newFuture;
    setState(() {
      _ordersFuture = newFuture;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            "My Orders",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          bottom: const TabBar(
            labelColor: Color(0xFF6C63FF), // AppColors.primary
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF6C63FF),
            tabs: [
              Tab(text: "Payment"),
              Tab(text: "In Progress"),
              Tab(text: "History"),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshOrders,
          child: FutureBuilder(
            future: _ordersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(child: Text("Error: ${snapshot.error}")),
                    ),
                  ],
                );
              }

              List<Order> allOrders = [];

              try {
                if (snapshot.data is Map) {
                  final results =
                      (snapshot.data as Map)['results'] as List<dynamic>? ?? [];
                  allOrders = results
                      .map(
                        (json) => Order.fromJson(json as Map<String, dynamic>),
                      )
                      .toList();
                } else if (snapshot.data is List) {
                  allOrders = (snapshot.data as List)
                      .map(
                        (json) => Order.fromJson(json as Map<String, dynamic>),
                      )
                      .toList();
                }
              } catch (e) {
                return ListView(
                  children: [Center(child: Text("Error parsing data: $e"))],
                );
              }

              // 1. Payment (Pending Payment)
              final paymentOrders = allOrders.where((o) {
                return o.paymentStatus.toUpperCase() != 'PAID' &&
                    o.status.toUpperCase() != 'CANCELLED';
              }).toList();

              // 2. In Progress (Paid & Not Completed/Cancelled)
              final inProgressOrders = allOrders.where((o) {
                final s = o.status.toUpperCase();
                return o.paymentStatus.toUpperCase() == 'PAID' &&
                    !['COMPLETED', 'CANCELLED', 'REJECTED'].contains(s);
              }).toList();

              // 3. History (Completed/Cancelled/Rejected)
              final historyOrders = allOrders.where((o) {
                final s = o.status.toUpperCase();
                return ['COMPLETED', 'CANCELLED', 'REJECTED'].contains(s);
              }).toList();

              return TabBarView(
                children: [
                  _buildOrderList(paymentOrders, "No pending payments"),
                  _buildOrderList(inProgressOrders, "No orders in progress"),
                  _buildOrderList(historyOrders, "No order history"),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders, String emptyMsg) {
    if (orders.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 100),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 64,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(emptyMsg, style: TextStyle(color: Colors.grey.shade500)),
              ],
            ),
          ),
        ],
      );
    }
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: orders.length,
      padding: const EdgeInsets.all(20),
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderCard(
          order: order,
          onTap: () {
            Get.to(() => OrderDetailScreen(order: order));
          },
        );
      },
    );
  }
}
