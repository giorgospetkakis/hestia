import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final http.Client _client = http.Client();

  // Headers for API requests
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // Generic GET request
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await _client.get(
        Uri.parse(endpoint),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Generic POST request
  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _client.post(
        Uri.parse(endpoint),
        headers: _headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Health check
  Future<bool> healthCheck() async {
    try {
      final response = await _client.get(
        Uri.parse(AppConfig.healthEndpoint),
        headers: _headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Detailed health check with response data
  Future<Map<String, dynamic>> healthCheckDetailed() async {
    try {
      final response = await _client.get(
        Uri.parse(AppConfig.healthEndpoint),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return {
          'status': 'healthy',
          'statusCode': response.statusCode,
          'data': json.decode(response.body),
          'timestamp': DateTime.now().toIso8601String(),
        };
      } else {
        return {
          'status': 'unhealthy',
          'statusCode': response.statusCode,
          'error': 'HTTP ${response.statusCode}',
          'timestamp': DateTime.now().toIso8601String(),
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'statusCode': null,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  // Check API route status
  Future<Map<String, dynamic>> checkRouteStatus(
      String route, String endpoint) async {
    try {
      final response = await _client.get(
        Uri.parse(endpoint),
        headers: _headers,
      );

      return {
        'route': route,
        'status': response.statusCode == 200 ? 'online' : 'error',
        'statusCode': response.statusCode,
        'responseTime': DateTime.now().millisecondsSinceEpoch,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'route': route,
        'status': 'offline',
        'statusCode': null,
        'error': e.toString(),
        'responseTime': DateTime.now().millisecondsSinceEpoch,
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  // Get all API routes status
  Future<List<Map<String, dynamic>>> getAllRoutesStatus() async {
    final routes = [
      {'name': 'Health Check', 'endpoint': AppConfig.healthEndpoint},
      {'name': 'Root API', 'endpoint': AppConfig.apiBaseUrl},
      {'name': 'Meals API', 'endpoint': AppConfig.mealsEndpoint},
    ];

    final results = <Map<String, dynamic>>[];

    for (final route in routes) {
      final status = await checkRouteStatus(route['name']!, route['endpoint']!);
      results.add(status);
    }

    return results;
  }

  // Get meals
  Future<List<Map<String, dynamic>>> getMeals() async {
    final response = await get(AppConfig.mealsEndpoint);
    return List<Map<String, dynamic>>.from(response['meals'] ?? []);
  }
}
