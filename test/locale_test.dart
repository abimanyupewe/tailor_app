import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tailor_app/controllers/locale_controller.dart';
import 'package:tailor_app/l10n/generated/app_localizations.dart';
import 'package:tailor_app/screens/profile/settings_screen.dart';

void main() {
  setUp(() {
    Get.reset();
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('ganti bahasa English -> Indonesia', (tester) async {
    Get.put(LocaleController(), permanent: true);
    await tester.pumpWidget(
      Obx(
        () => GetMaterialApp(
          locale: Get.find<LocaleController>().locale.value,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);

    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    expect(find.text('Choose Language'), findsOneWidget);

    final radioId = find.byWidgetPredicate(
      (w) => w is Radio<String> && w.value == 'id',
    );
    expect(radioId, findsOneWidget);
    await tester.tap(radioId);
    await tester.pumpAndSettle();

    expect(Get.find<LocaleController>().locale.value.languageCode, 'id');
    expect(find.text('Pengaturan'), findsOneWidget);
    expect(find.text('Bahasa'), findsOneWidget);
  });

  test('pilihan bahasa tersimpan dan dipakai saat cold start', () async {
    final controller = LocaleController();
    await controller.changeLocale(const Locale('id'));
    expect(controller.locale.value.languageCode, 'id');

    final restored = LocaleController(
      savedCode: 'id',
      deviceLocale: const Locale('en'),
    );
    expect(restored.locale.value.languageCode, 'id');
    expect(restored.languageName, 'Bahasa Indonesia');
  });
}
