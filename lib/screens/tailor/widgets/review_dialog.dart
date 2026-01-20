import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/data/api_service.dart';

class ReviewDialog extends StatefulWidget {
  final int orderId;
  const ReviewDialog({super.key, required this.orderId});

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  int _rating = 5;
  final TextEditingController _commentController = TextEditingController();
  final ApiService _apiService = Get.find<ApiService>();
  bool _isLoading = false;

  Future<void> _submitReview() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _apiService.createReview({
        'order': widget.orderId,
        'rating': _rating,
        'comment': _commentController.text,
      });
      Get.back(result: 'success'); // Return 'success' string
    } catch (e) {
      if (e.toString().contains("review with this order already exists")) {
        // If review already exists, we should probably just close and refresh
        Get.back(result: 'refresh');
        Get.snackbar(
          "Review Exists",
          "You have already reviewed this order.",
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.orange.shade900,
        );
      } else {
        Get.snackbar(
          "Error",
          e.toString(),
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Rate your experience",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: "Write a comment (optional)...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Submit Review",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
