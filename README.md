# Tailor App

Tailor App adalah aplikasi mobile berbasis Flutter yang dirancang untuk mempertemukan pelanggan dengan penyedia jasa jahit (penjahit). Aplikasi ini memfasilitasi pencarian penjahit terdekat berdasarkan lokasi pengguna, menampilkan rute navigasi, dan memungkinkan pengguna untuk memesan layanan jahit secara digital.

## Daftar Isi

1. [Tentang Aplikasi](#tentang-aplikasi)
2. [Teknologi yang Digunakan](#teknologi-yang-digunakan)
3. [Fitur Utama](#fitur-utama)
4. [Struktur Proyek](#struktur-proyek)
5. [Dokumentasi Teknis: Modul Peta](#dokumentasi-teknis-modul-peta)
6. [Instalasi dan Konfigurasi](#instalasi-dan-konfigurasi)

---

## Tentang Aplikasi

Aplikasi ini bertujuan untuk mendigitalisasi industri jasa jahit dengan memberikan platform bagi penjahit untuk memasarkan jasa mereka dan memudahkan pelanggan menemukan layanan yang sesuai. Fokus utama pengembangan saat ini adalah pada integrasi peta digital dan manajemen lokasi yang presisi.

## Teknologi yang Digunakan

Proyek ini dikembangkan menggunakan teknologi dan pustaka (library) berikut:

### Inti (Core)
*   **Flutter SDK**: ^3.8.1
*   **Bahasa Pemrograman**: Dart
*   **Manajemen State**: GetX (untuk manajemen state reaktif, routing, dan dependency injection).

### Peta dan Lokasi
*   **flutter_map**: Menampilkan peta berbasis OpenStreetMap.
*   **geolocator**: Mengakses layanan GPS/Lokasi perangkat pengguna.
*   **latlong2**: Utilitas untuk manipulasi koordinat Latitude dan Longitude.
*   **flutter_map_location_marker**: Menampilkan indikator lokasi pengguna pada peta.

### Utilitas dan UI
*   **http**: Klien HTTP untuk komunikasi dengan API Backend.
*   **shared_preferences**: Penyimpanan data lokal sederhana (key-value pair).
*   **google_fonts**: Kustomisasi tipografi aplikasi.
*   **iconsax**: Set ikon antarmuka modern.
*   **introduction_screen**: Layar pengenalan (onboarding) untuk pengguna baru.
*   **carousel_slider**: Komponen slider gambar.

---

## Fitur Utama

1.  **Pencarian Berbasis Lokasi**: Menemukan penjahit dalam radius tertentu dari lokasi pengguna.
2.  **Peta Interaktif**: Visualisasi lokasi penjahit dan pengguna menggunakan OpenStreetMap.
3.  **Navigasi & Routing**: Menampilkan rute perjalanan dari lokasi pengguna ke lokasi penjahit.
4.  **Autentikasi Pengguna**: Login dan Registrasi pengguna.
5.  **Profil Penjahit**: Informasi detail mengenai layanan dan portofolio penjahit.

---

## Struktur Proyek

Berikut adalah struktur direktori utama di dalam folder `lib/` beserta penjelasannya:

```
lib/
├── controllers/     # Logika bisnis dan State Management (GetX Controllers)
│   └── map_controller.dart  # Controller sentral untuk logika peta dan lokasi
├── models/          # Model data (Serialisasi JSON)
├── screens/         # Tampilan Antarmuka Pengguna (Screens/Pages)
│   ├── auth/        # Layar Autentikasi (Login, Register)
│   ├── home/        # Layar Utama
│   ├── map/         # Layar Peta
│   ├── order/       # Layar Pemesanan
│   └── tailor/      # Layar Detail Penjahit
├── services/        # Lapisan komunikasi data (Repository/API Calls)
│   └── map_repository.dart
├── widgets/         # Komponen UI yang dapat digunakan kembali (Reusable Widgets)
├── data/            # Penyedia data atau konfigurasi statis
└── main.dart        # Titik masuk aplikasi (Entry Point)
```

---

## Dokumentasi Teknis: Modul Peta

Fitur paling kompleks dalam aplikasi ini adalah manajemen Peta dan Lokasi. Seluruh logika ini dikelola di dalam `MapControllerX` yang berlokasi di `lib/controllers/map_controller.dart`. Berikut adalah dokumentasi untuk fungsi-fungsi vital di dalamnya.

### 1. Pemantauan Lokasi Real-time (Geolocator)

Aplikasi menggunakan `Geolocator` untuk memantau pergerakan pengguna secara waktu nyata (real-time). Stream posisi diinisialisasi untuk memperbarui state lokasi setiap kali pengguna berpindah tempat.

```dart
// Di dalam MapControllerX
void _startPositionStream() {
  const locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high, // Akurasi tinggi untuk navigasi presisi
    distanceFilter: 10,              // Pembaruan dipicu jika berpindah > 10 meter
  );

  _positionStreamSubscription = Geolocator.getPositionStream(
    locationSettings: locationSettings,
  ).listen((Position position) {
    // Memperbarui variabel reaktif lokasi saat ini
    currentLocation.value = LatLng(position.latitude, position.longitude);
    
    // Memeriksa status kedatangan jika dalam mode routing
    _checkArrival();
  });
}
```

**Penjelasan Logika**: Sistem berlangganan (subscribe) ke stream posisi perangkat. `distanceFilter: 10` memastikan aplikasi efisien dengan hanya memproses perubahan lokasi yang signifikan (lebih dari 10 meter).

### 2. Fitur Routing (Rute ke Penjahit)

Ketika pengguna memilih penjahit dan mengaktifkan navigasi, aplikasi akan mengambil data rute antartitik.

```dart
Future<void> toggleRouting() async {
  isRoutingMode.value = !isRoutingMode.value;

  if (isRoutingMode.value) {
    // Mengambil titik koordinat rute dari Repository
    final points = await _repository.getRoute(
      currentLocation.value!.latitude,
      currentLocation.value!.longitude,
      selectedTailor.value!.latitude,
      selectedTailor.value!.longitude,
    );
    
    // Menyimpan titik rute untuk dirender sebagai Polyline pada peta
    routePoints.assignAll(points.map((p) => LatLng(p[0], p[1])).toList());
  }
}
```

### 3. Logika Deteksi Kedatangan

Fungsi ini berjalan secara otomatis setiap kali lokasi pengguna diperbarui, untuk memeriksa apakah pengguna sudah mencapai lokasi tujuan.

```dart
void _checkArrival() {
  // Logika hanya berjalan jika mode routing aktif
  if (!isRoutingMode.value) return;

  // Menghitung jarak geodesik (dalam meter)
  final distance = const Distance().as(
    LengthUnit.Meter,
    currentLocation.value!,
    LatLng(selectedTailor.value!.latitude, selectedTailor.value!.longitude),
  );

  // Ambang batas kedatangan adalah 50 meter
  if (distance < 50) {
    isRoutingMode.value = false; // Nonaktifkan mode routing
    Get.dialog(ArrivalDialog(...)); // Tampilkan notifikasi kedatangan
  }
}
```

### 4. Optimalisasi Pencarian (Debounce)

Untuk mencegah permintaan API yang berlebihan saat pengguna mengetik kata kunci pencarian, diterapkan teknik *Debounce*.

```dart
// Timer menunda eksekusi selama 800ms setelah pengetikan terakhir
_debounceTimer = Timer(const Duration(milliseconds: 800), () async {
  // Eksekusi pemanggilan API pencarian
});
```

---

## Instalasi dan Konfigurasi

Ikuti langkah-langkah berikut untuk menjalankan proyek ini di lingkungan pengembangan lokal Anda.

### Prasyarat
1.  **Flutter SDK**: Pastikan versi Flutter terinstal sesuai dengan `environment.sdk` di `pubspec.yaml`.
2.  **IDE**: Visual Studio Code atau Android Studio dengan ekstensi Dart dan Flutter.
3.  **Emulator/Device**: Perangkat Android/iOS atau Emulator yang berjalan.

### Langkah Instalasi

1.  **Clone Repository**
    Salin kode sumber ke mesin lokal Anda:
    ```bash
    git clone <url-repository-anda>
    cd tailor_app
    ```

2.  **Instalasi Dependensi**
    Unduh semua pustaka yang diperlukan:
    ```bash
    flutter pub get
    ```

3.  **Jalankan Aplikasi**
    Pastikan emulator atau perangkat terhubung, lalu jalankan perintah:
    ```bash
    flutter run
    ```

### Pemecahan Masalah Umum

*   **Masalah Izin Lokasi**: Jika peta tidak menampilkan lokasi, pastikan izin lokasi (Location Permission) telah diberikan pada pengaturan perangkat atau emulator.
*   **Koneksi API**: Pastikan URL API backend yang dikonfigurasi dapat diakses dari emulator/perangkat (gunakan IP lokal host jika perlu, misalnya `10.0.2.2` untuk emulator Android).
