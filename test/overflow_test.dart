import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tailor_app/controllers/order_controller.dart';
import 'package:tailor_app/controllers/service_controller.dart';
import 'package:tailor_app/data/api_service.dart';
import 'package:tailor_app/l10n/generated/app_localizations.dart';
import 'package:tailor_app/models/tailor_model.dart';
import 'package:tailor_app/screens/order/order_screen.dart';
import 'package:tailor_app/screens/tailor/manage_services_screen.dart';
import 'package:tailor_app/screens/tailor/tailor_detail_screen.dart';
import 'package:tailor_app/screens/tailor/widgets/tailor_tabs.dart';
import 'package:tailor_app/widgets/services_grid.dart';
import 'package:iconsax/iconsax.dart';

// ignore_for_file: must_call_super

class _FakeApiService extends ApiService {
  @override
  void onInit() {
    baseUrl = 'http://localhost';
  }

  @override
  Future<dynamic> getMyServices() async => {
        'count': 1,
        'results': [
          {
            'id': 1,
            'name': 'Jahit Kebaya Custom Bordir Payet',
            'base_price': '1500000.00',
            'description':
                'Kebaya full bordir tangan dengan payet premium, pengerjaan detail.',
            'estimated_duration_days': 30,
            'is_active': true,
          },
        ],
      };
}

final _longService = Service(
  id: 1,
  name: 'Jahit Kebaya Custom Bordir Payet',
  price: 1500000,
  description:
      'Kebaya full bordir tangan dengan payet premium, pengerjaan sangat detail.',
  estimatedDurationDays: 30,
);

final _tailor = Tailor(
  id: '1',
  name: "pak_joko's Shop",
  address: 'Jl. Mawar No. 1 Semarang',
  rating: 4.5,
  reviewCount: 120,
  imageUrl: '',
  latitude: 0,
  longitude: 0,
  distance: 1.2,
  isVerified: true,
  services: [_longService],
  reviews: const [],
  phoneNumber: '08123456789',
  posts: const [],
);

Future<void> _pumpAt(
  WidgetTester tester,
  Widget child, {
  double width = 320,
}) async {
  tester.view.physicalSize = Size(width, 720);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(Get.reset);

  testWidgets('ServiceTab tidak overflow di 320px', (tester) async {
    await _pumpAt(tester, Scaffold(body: ServiceTab(tailor: _tailor)));
    expect(tester.takeException(), isNull);
  });

  testWidgets('ServicesGrid tidak overflow di 320px', (tester) async {
    await _pumpAt(
      tester,
      Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ServicesGrid(
            services: const [
              ServiceEntry(
                label: 'Konsultasi Desain',
                query: 'desain',
                icon: Iconsax.magicpen,
                background: Colors.white,
                foreground: Colors.black,
              ),
              ServiceEntry(
                label: 'Ubah Ukuran',
                query: 'ukuran',
                icon: Iconsax.ruler,
                background: Colors.white,
                foreground: Colors.black,
              ),
              ServiceEntry(
                label: 'Jahit Kilat',
                query: 'kilat',
                icon: Iconsax.timer,
                background: Colors.white,
                foreground: Colors.black,
              ),
              ServiceEntry(
                label: 'Jahit Baru',
                query: 'jahit',
                icon: Iconsax.scissor,
                background: Colors.white,
                foreground: Colors.black,
              ),
            ],
            onSelect: (_) {},
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('OrderScreen tidak overflow di 320px', (tester) async {
    Get.put<ApiService>(_FakeApiService());
    await _pumpAt(tester, OrderScreen(tailor: _tailor));
    expect(tester.takeException(), isNull);
  });

  testWidgets('ManageServicesScreen tidak overflow di 320px', (tester) async {
    Get.put<ApiService>(_FakeApiService());
    await _pumpAt(tester, const ManageServicesScreen());
    expect(tester.takeException(), isNull);
  });

  testWidgets('TailorDetailScreen bottom bar tidak overflow di 360px', (
    tester,
  ) async {
    Get.put<ApiService>(_FakeApiService());
    await _pumpAt(tester, TailorDetailScreen(tailor: _tailor), width: 360);
    expect(tester.takeException(), isNull);
  });

  testWidgets('TailorDetailScreen bottom bar tidak overflow di 320px', (
    tester,
  ) async {
    Get.put<ApiService>(_FakeApiService());
    await _pumpAt(tester, TailorDetailScreen(tailor: _tailor));
    expect(tester.takeException(), isNull);
  });
}
