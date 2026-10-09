import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/l10n/generated/app_localizations.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String snapToken;
  const PaymentWebViewScreen({super.key, required this.snapToken});

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Default to Sandbox. For production, change domain.
    final url =
        'https://app.sandbox.midtrans.com/snap/v2/vtweb/${widget.snapToken}';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            print("Webview error: ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) {
            // Handle redirect or callbacks from Midtrans
            // Likely Midtrans redirects to valid_url?status_code=xxx...
            if (request.url.contains('status_code=200') ||
                request.url.contains('transaction_status=settlement') ||
                request.url.contains('transaction_status=capture')) {
              Get.back(result: 'success');
              return NavigationDecision.prevent;
            }
            if (request.url.contains('status_code=202') ||
                request.url.contains('transaction_status=denied')) {
              Get.back(result: 'failed');
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(AppLocalizations.of(context).tabPayment),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Confirm close?
            Get.back();
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading)
            const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        ],
      ),
    );
  }
}
