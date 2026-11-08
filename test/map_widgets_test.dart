import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tailor_app/controllers/map_controller.dart';
import 'package:tailor_app/controllers/tailor_controller.dart';
import 'package:tailor_app/data/api_service.dart';
import 'package:tailor_app/l10n/generated/app_localizations.dart';
import 'package:tailor_app/models/tailor_model.dart';
import 'package:tailor_app/screens/map/widgets/route_timeline_widget.dart';
import 'package:tailor_app/screens/map/widgets/search_input_widget.dart';
import 'package:tailor_app/screens/map/widgets/tailor_detail_sheet.dart';
import 'package:tailor_app/screens/map/widgets/tailor_list_sheet.dart';

// ignore_for_file: must_call_super

class _FakeApiService extends ApiService {
  @override
  void onInit() {
    baseUrl = 'http://localhost';
  }
}

/// Skips the geolocator bootstrap so the sheets can be laid out in tests.
class _FakeMapController extends MapControllerX {
  @override
  void onInit() {}
}

/// Skips the network fetch; tests seed [tailors] directly.
class _FakeTailorController extends TailorController {
  @override
  void onInit() {}
}

Tailor _tailor(String id, String name, double distance) => Tailor(
  id: id,
  name: name,
  address: 'Jl. Mawar No. 1 Semarang',
  rating: 4.5,
  reviewCount: 12,
  imageUrl: '',
  latitude: -6.99,
  longitude: 110.42,
  distance: distance,
  isVerified: true,
  services: const [],
  reviews: const [],
  phoneNumber: '08123456789',
  posts: const [],
);

Future<void> _pumpWidget(
  WidgetTester tester,
  Widget child, {
  double width = 360,
}) async {
  tester.view.physicalSize = Size(width, 720);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: Stack(children: [child])),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.reset();
    Get.put<ApiService>(_FakeApiService());
    Get.put<MapControllerX>(_FakeMapController());
    Get.put<TailorController>(_FakeTailorController());
  });

  tearDown(Get.reset);

  testWidgets('list sheet kosong menampilkan empty state tanpa overflow', (
    tester,
  ) async {
    await _pumpWidget(tester, const TailorListSheet());
    expect(tester.takeException(), isNull);
    expect(find.text('Nearby Tailors'), findsOneWidget);
    expect(find.text('No tailors found'), findsOneWidget);
  });

  testWidgets('list sheet dengan penjahit tampil tanpa overflow di 320px', (
    tester,
  ) async {
    Get.find<TailorController>().tailors.assignAll([
      _tailor('1', 'Jahit Berkah', 0.4),
      _tailor('2', 'Jahit Makmur', 12.3),
    ]);
    await _pumpWidget(tester, const TailorListSheet(), width: 320);
    expect(tester.takeException(), isNull);
    expect(find.text('Jahit Berkah'), findsOneWidget);
    expect(find.text('Jahit Makmur'), findsOneWidget);
  });

  testWidgets('detail sheet tampil tanpa overflow di 320px', (tester) async {
    await _pumpWidget(
      tester,
      TailorDetailSheet(selected: _tailor('1', 'Jahit Berkah', 0.4)),
      width: 320,
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Jahit Berkah'), findsOneWidget);
  });

  testWidgets('search input tampil tanpa overflow', (tester) async {
    await _pumpWidget(
      tester,
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SearchInputWidget(),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('route timeline tampil tanpa overflow di 320px', (tester) async {
    await _pumpWidget(
      tester,
      const RouteTimelineWidget(),
      width: 320,
    );
    expect(tester.takeException(), isNull);
  });
}
