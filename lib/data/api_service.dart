import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ApiService extends GetxService {
  late final String baseUrl;
  String? _token;

  @override
  void onInit() {
    super.onInit();
    baseUrl = dotenv.env['URL_API'] ?? 'http://127.0.0.1:8000';
  }

  void setToken(String token) {
    _token = token;
  }

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  Future<dynamic> _handleResponse(http.Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  // --- Authentication ---
  Future<dynamic> registerCustomer(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/auth/register/'),
      headers: _headers,
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  Future<dynamic> registerTailor(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/auth/register-tailor/'),
      headers: _headers,
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  Future<dynamic> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/auth/login/'),
      headers: _headers,
      body: json.encode({'email': email, 'password': password}),
    );
    final data = await _handleResponse(response);
    if (data['access'] != null) {
      setToken(data['access']);
    }
    return data;
  }

  // --- User Profile ---
  Future<dynamic> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/profile/me/'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> updateProfile(Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/profile/me/'),
      headers: _headers,
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  Future<dynamic> getUsers({String? role}) async {
    String query = '';
    if (role != null) {
      query = '?role=$role';
    }
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/list/$query'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  // --- Tailor Features ---
  Future<dynamic> getMyLocation() async {
    final response = await http.get(
      Uri.parse('$baseUrl/tailor/manage/location/my_location/'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> setMyLocation(double lat, double lon, String address) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tailor/manage/location/my_location/'),
      headers: _headers,
      body: json.encode({
        'latitude': lat,
        'longitude': lon,
        'address': address,
      }),
    );
    return _handleResponse(response);
  }

  Future<dynamic> getMyServices() async {
    final response = await http.get(
      Uri.parse('$baseUrl/tailor/manage/services/'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> addService(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tailor/manage/services/'),
      headers: _headers,
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  Future<dynamic> addPost(Map<String, dynamic> data) async {
    // Note: Use MultipartRequest for file uploads if needed, assuming JSON for now as per prompt "POST"
    final response = await http.post(
      Uri.parse('$baseUrl/tailor/manage/posts/'),
      headers: _headers,
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  // --- Search & Homepage ---
  Future<List<dynamic>> getTailors({
    double? lat,
    double? lon,
    double? radius,
    String? search,
  }) async {
    String query = '?';
    if (lat != null && lon != null) query += 'lat=$lat&lon=$lon&';
    if (radius != null) query += 'radius=$radius&';
    if (search != null) query += 'search=$search&';

    final response = await http.get(
      Uri.parse('$baseUrl/tailor/list/$query'),
      headers: _headers,
    );
    final data = await _handleResponse(response);
    return List<dynamic>.from(data);
  }

  Future<dynamic> getTailorDetail(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/tailor/list/$id/'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  // --- Orders ---
  Future<dynamic> getOrders() async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders/'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> createOrder(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders/'),
      headers: _headers,
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  Future<dynamic> updateOrderStatus(String id, String status) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders/$id/status/'),
      headers: _headers,
      body: json.encode({'status': status}),
    );
    return _handleResponse(response);
  }

  // --- Reviews ---
  Future<dynamic> getReviews(String tailorId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/reviews/?tailor_id=$tailorId'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> createReview(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reviews/'),
      headers: _headers,
      body: json.encode(data),
    );
    return _handleResponse(response);
  }
}
