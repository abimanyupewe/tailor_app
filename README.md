# Tailor App

Tailor App adalah aplikasi mobile berbasis Flutter yang mempertemukan pelanggan dengan penjahit. Aplikasi ini memungkinkan pengguna untuk mencari penjahit terdekat, melihat rute, dan memesan layanan jahit.

## 🛠 Tech Stack

Project ini dibangun menggunakan teknologi dan package berikut:

-   **Framework**: [Flutter](https://flutter.dev/) (SDK ^3.8.1)
-   **Language**: Dart
-   **State Management**: [GetX](https://pub.dev/packages/get)
-   **Map & Location**:
    -   [`flutter_map`](https://pub.dev/packages/flutter_map): Untuk menampilkan peta (OpenStreetMap).
    -   [`geolocator`](https://pub.dev/packages/geolocator): Untuk mengakses lokasi GPS pengguna.
    -   [`latlong2`](https://pub.dev/packages/latlong2): Utilities untuk koordinat latitude/longitude.
    -   [`flutter_map_location_marker`](https://pub.dev/packages/flutter_map_location_marker): Menampilkan marker lokasi user di peta.
-   **HTTP Client**: `http`
-   **Storage**: `shared_preferences`
-   **UI/UX**: `google_fonts`, `iconsax`, `introduction_screen`, `carousel_slider`.

## 📂 Struktur Project

Struktur folder utama dalam `lib/` adalah sebagai berikut:

```
lib/
├── controllers/     # Logika bisnis dan State Management (GetX Controllers)
│   └── map_controller.dart  # Controller utama untuk fitur peta
├── models/          # Data models (JSON serialization)
├── screens/         # Tampilan UI (Pages/Views)
├── services/        # Logic API calls dan repository
│   └── map_repository.dart
├── widgets/         # Reusable widgets
├── data/            # Data providers / API services
└── main.dart        # Entry point aplikasi
```

## 🚀 Setup & Instalasi

Ikuti langkah berikut untuk menjalankan project ini di local machine Anda:

1.  **Prerequisites**:
    -   Pastikan Flutter SDK sudah terinstall.
    -   Pastikan Android Studio / VS Code sudah siap dengan plugin Flutter/Dart.

2.  **Clone Repository**:
    ```bash
    git clone <repository-url>
    cd tailor_app
    ```

3.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```

4.  **Run Aplikasi**:
    -   Pastikan emulator berjalan atau device terhubung.
    ```bash
    flutter run
    ```

## 📍 Penjelasan Kode Penting: Map & Geolocator

Fitur utama aplikasi ini adalah Peta dan Lokasi. Semua logika ini dihandle di dalam **`MapControllerX`** (`lib/controllers/map_controller.dart`).

### 1. Mendapatkan Lokasi Real-time (`Geolocator`)

Aplikasi menggunakan `Geolocator` untuk memantau pergerakan user secara real-time.

```dart
// Di dalam MapControllerX
void _startPositionStream() {
  const locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high, // Akurasi tinggi untuk navigasi
    distanceFilter: 10,              // Update hanya jika berpindah > 10 meter
  );

  _positionStreamSubscription = Geolocator.getPositionStream(
    locationSettings: locationSettings,
  ).listen((Position position) {
    // Update posisi saat ini di variable reactive
    currentLocation.value = LatLng(position.latitude, position.longitude);
    
    // Cek apakah sudah sampai (jika sedang routing)
    _checkArrival();
  });
}
```

*   **Logic**: Kita subscribe ke stream posisi. Setiap ada perubahan lokasi > 10 meter, `currentLocation` diupdate.

### 2. Fitur Routing (Rute ke Penjahit)

Saat user memilih penjahit dan menekan tombol navigasi/route:

```dart
Future<void> toggleRouting() async {
  isRoutingMode.value = !isRoutingMode.value;

  if (isRoutingMode.value) {
    // Fetch titik-titik koordinat rute dari API/Repository
    final points = await _repository.getRoute(
      currentLocation.value!.latitude,
      currentLocation.value!.longitude,
      selectedTailor.value!.latitude,
      selectedTailor.value!.longitude,
    );
    
    // Simpan titik rute untuk digambar sebagai Polyline di peta
    routePoints.assignAll(points.map((p) => LatLng(p[0], p[1])).toList());
  }
}
```

### 3. Deteksi Kedatangan (`_checkArrival`)

Fungsi ini dipanggil setiap kali lokasi user berubah. Ini mengecek jarak antara user dan penjahit tujuan.

```dart
void _checkArrival() {
  // Hanya jalan jika fitur routing aktif
  if (!isRoutingMode.value) return;

  // Hitung jarak (dalam meter)
  final distance = const Distance().as(
    LengthUnit.Meter,
    currentLocation.value!,
    LatLng(selectedTailor.value!.latitude, selectedTailor.value!.longitude),
  );

  // Jika jarak kurang dari 50 meter, anggap sudah sampai
  if (distance < 50) {
    isRoutingMode.value = false; // Matikan mode routing
    Get.dialog(ArrivalDialog(...)); // Tampilkan dialog "Sampai"
  }
}
```

### 4. Search & Debounce

Untuk fitur pencarian lokasi/penjahit, kita menggunakan **Debounce** agar tidak spam request API setiap user mengetik satu huruf.

```dart
// Timer akan menunggu 800ms setelah user berhenti mengetik
_debounceTimer = Timer(const Duration(milliseconds: 800), () async {
  // Lakukan pencarian ke API
});
```
