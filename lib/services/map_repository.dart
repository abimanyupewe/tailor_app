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

  Future<List<List<double>>> getRoute(
    double startLat,
    double startLon,
    double endLat,
    double endLon,
  ) async {
    // Using OSRM public demo server (router.project-osrm.org)
    // Format: /route/v1/driving/{lon},{lat};{lon},{lat}?overview=full&geometries=geojson
    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/$startLon,$startLat;$endLon,$endLat?overview=full&geometries=geojson',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final routes = data['routes'] as List;
        if (routes.isNotEmpty) {
          final geometry = routes[0]['geometry'];
          final coordinates = geometry['coordinates'] as List;

          return coordinates.map((coord) {
            final point = coord as List;
            // GeoJSON is [lon, lat], we return [lat, lon] for easy mapping
            return [point[1] as double, point[0] as double];
          }).toList();
        }
      }
      return [];
    } catch (e) {
      print('Route Error: $e');
      return [];
    }
  }
}
