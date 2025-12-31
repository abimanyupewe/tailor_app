import 'package:tailor_app/models/tailor_model.dart';

class Order {
  final int id;
  final String status;
  final String paymentStatus;
  final double totalPrice;
  final List<OrderItem> items;
  final DateTime createdAt;
  // potentially tailor info if backend provides it, otherwise we might just show ID
  // Assuming backend might send tailor name or we just show items.
  // Based on current JSON in OrderListScreen, we only saw id, items, total_price, status.

  Order({
    required this.id,
    required this.status,
    required this.paymentStatus,
    required this.totalPrice,
    required this.items,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      status: json['status'] ?? 'UNKNOWN',
      paymentStatus: json['payment_status'] ?? 'Unpaid',
      totalPrice:
          double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((i) => OrderItem.fromJson(i as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class OrderItem {
  final int id;
  final int quantity;
  final String? notes;
  final Service? service; // If backend expands service details
  final double price; // Price at time of order

  OrderItem({
    required this.id,
    required this.quantity,
    this.notes,
    this.service,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? 0,
      quantity: json['quantity'] ?? 1,
      notes: json['notes'],
      // Adapt based on actual API response structure for service
      // If service is just an ID, we might not get full details unless expanded
      service: json['service_details'] != null
          ? Service.fromJson(json['service_details'])
          : null,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
    );
  }
}
