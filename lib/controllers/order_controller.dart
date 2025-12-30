import 'package:get/get.dart';
import 'package:tailor_app/data/api_service.dart';
import 'package:tailor_app/models/tailor_model.dart';
import 'package:tailor_app/screens/order/payment_webview_screen.dart';

class OrderItem {
  final Service service;
  RxInt quantity = 0.obs;
  RxString notes = ''.obs;

  OrderItem(this.service);
}

class OrderController extends GetxController {
  final Tailor tailor;
  final RxList<OrderItem> items = <OrderItem>[].obs;
  final RxBool isLoading = false.obs;

  OrderController(this.tailor);

  @override
  void onInit() {
    super.onInit();
    // Initialize items based on tailor services
    items.assignAll(tailor.services.map((s) => OrderItem(s)).toList());
  }

  void increment(OrderItem item) {
    item.quantity.value++;
  }

  void decrement(OrderItem item) {
    if (item.quantity.value > 0) {
      item.quantity.value--;
    }
  }

  double get totalPrice {
    return items.fold(
      0.0,
      (sum, item) => sum + (item.service.price * item.quantity.value),
    );
  }

  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity.value);
  }

  Future<void> createOrder() async {
    final activeItems = items.where((i) => i.quantity.value > 0).toList();
    if (activeItems.isEmpty) {
      Get.snackbar("Error", "Please select at least one service");
      return;
    }

    isLoading.value = true;
    try {
      final apiService = Get.find<ApiService>();

      // Construct payload
      final payload = {
        "tailor": int.tryParse(tailor.id) ?? 0,
        "items": activeItems
            .map(
              (item) => {
                "service": item.service.id,
                "quantity": item.quantity.value,
                "notes": item.notes.value,
              },
            )
            .toList(),
      };

      final response = await apiService.createOrder(payload);
      print("Order Response: $response");

      if (response != null && response['snap_token'] != null) {
        final snapToken = response['snap_token'];
        final orderId = response['id'].toString();

        // Navigate to Payment WebView
        final result = await Get.to(
          () => PaymentWebViewScreen(snapToken: snapToken),
        );

        if (result == 'success') {
          try {
            // Notify backend that payment is successful
            await apiService.updateOrderStatus(orderId, 'PAID');
            print("Order status updated to PAID");
          } catch (e) {
            print("Failed to auto-update status: $e");
          }

          Get.snackbar("Success", "Payment Successful!");
          Get.offNamedUntil('/', (route) => false);
        } else {
          // Payment cancelled or failed, but order created.
          Get.snackbar("Order Placed", "Payment pending. Check My Orders.");
          Get.back();
        }
      } else {
        Get.snackbar("Success", "Order placed successfully!");
        Get.back();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to create order: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
