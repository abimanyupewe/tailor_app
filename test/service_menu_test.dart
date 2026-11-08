import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tailor_app/controllers/service_controller.dart';
import 'package:tailor_app/core/utils/currency.dart';
import 'package:tailor_app/data/api_service.dart';
import 'package:tailor_app/l10n/generated/app_localizations.dart';
import 'package:tailor_app/models/tailor_model.dart';
import 'package:tailor_app/screens/tailor/widgets/tailor_tabs.dart';

// ignore_for_file: must_call_super

class _FakeApiService extends ApiService {
  final List<Map<String, dynamic>> stored = [];
  int _nextId = 1;
  Map<String, dynamic>? lastPayload;
  int? deletedId;

  @override
  void onInit() {
    baseUrl = 'http://localhost';
  }

  @override
  Future<dynamic> getMyServices() async {
    return {'count': stored.length, 'results': stored};
  }

  @override
  Future<dynamic> addService(Map<String, dynamic> data) async {
    lastPayload = data;
    stored.add({'id': _nextId++, ...data});
    return stored.last;
  }

  @override
  Future<dynamic> updateService(int id, Map<String, dynamic> data) async {
    lastPayload = data;
    final i = stored.indexWhere((s) => s['id'] == id);
    if (i != -1) stored[i] = {'id': id, ...data};
    return stored[i == -1 ? 0 : i];
  }

  @override
  Future<dynamic> deleteService(int id) async {
    deletedId = id;
    stored.removeWhere((s) => s['id'] == id);
    return null;
  }
}

Service _service({
  int id = 1,
  String name = 'Jahit Kemeja',
  bool isActive = true,
  int duration = 3,
  double price = 50000,
}) {
  return Service(
    id: id,
    name: name,
    price: price,
    description: '',
    estimatedDurationDays: duration,
    isActive: isActive,
  );
}

Tailor _tailor(List<Service> services) {
  return Tailor(
    id: '1',
    name: "pak_joko's Shop",
    address: 'Jl. Mawar 1',
    rating: 4.5,
    reviewCount: 2,
    imageUrl: '',
    latitude: 0,
    longitude: 0,
    distance: 1,
    isVerified: true,
    services: services,
    reviews: [],
    phoneNumber: '08',
    posts: [],
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(Get.reset);

  test('formatRupiah memakai pemisah ribuan Indonesia', () {
    expect(formatRupiah(15000), 'Rp 15.000');
    expect(formatRupiah(1500000), 'Rp 1.500.000');
    expect(formatRupiah(500), 'Rp 500');
  });

  test('Service.fromJson membaca is_active & estimated_duration_days', () {
    final s = Service.fromJson({
      'id': 7,
      'name': 'Permak',
      'base_price': '25000.00',
      'description': 'Potong lengan',
      'estimated_duration_days': 2,
      'is_active': false,
    });
    expect(s.id, 7);
    expect(s.price, 25000);
    expect(s.estimatedDurationDays, 2);
    expect(s.isActive, isFalse);
  });

  test('activeServices menyembunyikan layanan nonaktif', () {
    final tailor = _tailor([
      _service(id: 1, name: 'Aktif'),
      _service(id: 2, name: 'Mati', isActive: false),
    ]);
    expect(tailor.activeServices.map((s) => s.name), ['Aktif']);
  });

  testWidgets('ServiceTab tidak menampilkan layanan nonaktif', (tester) async {
    final tailor = _tailor([
      _service(id: 1, name: 'Jahit Baru'),
      _service(id: 2, name: 'Layanan Mati', isActive: false),
    ]);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: ServiceTab(tailor: tailor)),
      ),
    );

    expect(find.text('Jahit Baru'), findsOneWidget);
    expect(find.text('Layanan Mati'), findsNothing);
  });

  test('ServiceController memuat, menyimpan, dan menghapus layanan', () async {
    final fake = _FakeApiService();
    Get.put<ApiService>(fake);
    final controller = ServiceController();
    await controller.loadServices();
    expect(controller.services, isEmpty);

    final error = await controller.save(
      name: 'Jahit Kemeja',
      price: 50000,
      description: 'Custom',
      durationDays: 3,
      isActive: true,
    );
    expect(error, isNull);
    expect(fake.lastPayload!['base_price'], '50000.00');
    expect(fake.lastPayload!['estimated_duration_days'], 3);
    expect(controller.services.length, 1);

    await controller.remove(controller.services.first);
    expect(fake.deletedId, 1);
    expect(controller.services, isEmpty);
  });
}
