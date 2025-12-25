import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MapRepository {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  Future<List<Map<String, dynamic>>> searchLocation(String query) async {
    final url = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': query,
      'format': 'json',
      'addressdetails': '1',
      'limit': '5',
    });

    try {
      final response = await http.get(
        url,
        headers: {'User-Agent': 'tailor_app/1.0', 'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to load location data');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<String> getAddressFromCoordinates(double lat, double lon) async {
    final url = Uri.https('nominatim.openstreetmap.org', '/reverse', {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'format': 'json',
      'addressdetails': '1',
    });

    try {
      final response = await http.get(
        url,
        headers: {'User-Agent': 'tailor_app/1.0', 'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['address'];
        if (address != null) {
          return address['road'] ??
              address['pedestrian'] ??
              address['street'] ??
              address['suburb'] ??
              address['village'] ??
              data['display_name']?.toString().split(',').first ??
              'Unknown Location';
        }
        return data['display_name']?.toString().split(',').first ??
            'Unknown Location';
      } else {
        throw Exception('Failed to load address');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
