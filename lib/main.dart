import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tailor_app/bindings/initial_binding.dart';
import 'package:tailor_app/controllers/locale_controller.dart';
import 'package:tailor_app/l10n/generated/app_localizations.dart';
import 'package:tailor_app/routes/app_routes.dart';

import 'package:tailor_app/theme/app_theme.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final prefs = await SharedPreferences.getInstance();
  Get.put(
    LocaleController(
      savedCode: prefs.getString(LocaleController.storageKey),
      deviceLocale: Get.deviceLocale,
    ),
    permanent: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tailor App',
        theme: AppTheme.light,
        locale: localeController.locale.value,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        initialBinding: InitialBinding(),
        initialRoute: AppRoutes.initial,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        // home: const MainWrapper(),
      ),
    );
  }
}
