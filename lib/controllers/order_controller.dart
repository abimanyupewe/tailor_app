import 'package:get/get.dart';
import 'package:tailor_app/data/api_service.dart';
import 'package:tailor_app/models/tailor_model.dart';
import 'package:tailor_app/screens/order/payment_webview_screen.dart';
import 'package:tailor_app/controllers/profile_controller.dart';
import 'package:flutter/material.dart';

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

  // Scheduling Properties
  final Rx<DateTime> selectedDate = DateTime.now().obs;

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

      // VALIDATION: Check if user has a valid email for Midtrans
      // Try to find ProfileController to check data
      try {
        if (Get.isRegistered<ProfileController>()) {
          final profileC = Get.find<ProfileController>();
          final user = profileC.user.value;
          // Structure based on earlier observation: user['user']['email']
          final email = user?['user']?['email']?.toString() ?? '';

          final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
          ).hasMatch(email);

          if (email.isEmpty || !emailValid) {
            isLoading.value = false;
            Get.snackbar(
              "Email Tidak Valid",
              "Midtrans memerlukan email yang valid untuk pembayaran. Mohon update profil Anda.",
              backgroundColor: Get.theme.colorScheme.error,
              colorText: Get.theme.colorScheme.onError,
              duration: const Duration(seconds: 5),
              mainButton: TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  "Update Profile",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
            return;
          }
        }
      } catch (e) {
        print("Warning: Could not validate email via ProfileController: $e");
      }

      // Prepare schedule string
      final date = selectedDate.value;
      final dateStr = "${date.day}/${date.month}/${date.year}";
      final scheduleInfo = " | Scheduled: $dateStr";

      // Construct payload
      final payload = {
        "tailor": int.tryParse(tailor.id) ?? 0,
        "items": activeItems.map((item) {
          // Append schedule to notes
          String finalNote = item.notes.value;
          if (finalNote.isEmpty) {
            finalNote = "Scheduled: $dateStr";
          } else {
            finalNote += scheduleInfo;
          }

          return {
            "service": item.service.id,
            "quantity": item.quantity.value,
            "notes": finalNote,
          };
        }).toList(),
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
