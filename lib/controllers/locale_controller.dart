import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App language state. Persisted in SharedPreferences, defaults to the
/// device locale when it is `en`/`id`.
///
/// Screens that render localized strings inside a GetX `Obx` must read
/// [locale] in the builder (see home/profile) so the `Obx` resubscribes
/// and rebuilds on language switch. That keeps the switch deterministic
/// without `performReassemble` (hot-reload path, unsafe in tests/release).
class LocaleController extends GetxController {
  static const storageKey = 'app_locale';
  static const supported = [Locale('en'), Locale('id')];

  final locale = const Locale('en').obs;

  LocaleController({String? savedCode, Locale? deviceLocale}) {
    if (savedCode != null && _isSupported(savedCode)) {
      locale.value = Locale(savedCode);
    } else if (deviceLocale != null && _isSupported(deviceLocale.languageCode)) {
      locale.value = Locale(deviceLocale.languageCode);
    }
  }

  static bool _isSupported(String code) =>
      supported.any((l) => l.languageCode == code);

  String get languageName =>
      locale.value.languageCode == 'id' ? 'Bahasa Indonesia' : 'English';

  Future<void> changeLocale(Locale next) async {
    if (!_isSupported(next.languageCode)) return;
    if (locale.value == next) return;
    locale.value = next;
    // GetMaterialApp resolves `Get.locale ?? locale`, so the passed `locale:`
    // alone is ignored after startup. Set both (no reassemble needed: the
    // Obx around GetMaterialApp plus resubscribed Obxs rebuild deterministically).
    Get.locale = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, next.languageCode);
  }
}
