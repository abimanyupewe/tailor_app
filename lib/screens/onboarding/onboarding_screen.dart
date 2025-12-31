import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/routes/app_routes.dart';
import 'package:iconsax/iconsax.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  int _currentPage = 0;

  Future<void> _onIntroEnd(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_time', false);
    // Navigate to Login after onboarding
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 16.0, color: Colors.grey);
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return Stack(
      children: [
        IntroductionScreen(
          key: introKey,
          globalBackgroundColor: Colors.white,
          allowImplicitScrolling: true,
          autoScrollDuration: 3000,
          infiniteAutoScroll: false,
          pages: [
            PageViewModel(
              title: "Find Your Tailor",
              body:
                  "Easily find the best professional tailors near you with just a few clicks.",
              image: const Icon(
                Iconsax.search_status,
                size: 150,
                color: AppColors.primary,
              ),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Custom Measurements",
              body:
                  "Provide your exact measurements online or book an appointment for measuring.",
              image: const Icon(
                Iconsax.ruler,
                size: 150,
                color: AppColors.primary,
              ),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Fast Delivery",
              body:
                  "Get your custom clothes delivered right to your doorstep, hassle-free.",
              image: const Icon(
                Iconsax.box,
                size: 150,
                color: AppColors.primary,
              ),
              decoration: pageDecoration,
            ),
          ],
          onDone: () => _onIntroEnd(context),
          onSkip: () =>
              _onIntroEnd(context), // You can override onSkip callback
          showSkipButton: true,
          skipOrBackFlex: 0,
          nextFlex: 0,
          showBackButton: _currentPage != 2,
          showNextButton: _currentPage != 2,
          isProgress: _currentPage != 2,
          //rtl: true, // Display as right-to-left
          back: const Text(
            'Back',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          skip: const Text(
            'Skip',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          next: const Text(
            'Next',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          showDoneButton: false,
          onChange: (index) => setState(() => _currentPage = index),
          globalFooter: _currentPage == 2
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _onIntroEnd(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
              : null,
          curve: Curves.fastLinearToSlowEaseIn,
          controlsMargin: const EdgeInsets.all(16),
          controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
          dotsDecorator: const DotsDecorator(
            size: Size(10.0, 10.0),
            color: Color(0xFFBDBDBD),
            activeSize: Size(22.0, 10.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
            activeColor: AppColors.primary,
          ),
        ),
        if (_currentPage == 2)
          Positioned(
            top: 50,
            left: 16,
            child: TextButton(
              onPressed: () => introKey.currentState?.previous(),
              child: const Text(
                'Back',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
