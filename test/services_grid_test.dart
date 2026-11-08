import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_app/widgets/services_grid.dart';

List<ServiceEntry> _longLabels() => const [
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
];

void main() {
  testWidgets('services grid tidak overflow di layar 360px', (tester) async {
    tester.view.physicalSize = const Size(360, 690);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ServicesGrid(services: _longLabels(), onSelect: (_) {}),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
