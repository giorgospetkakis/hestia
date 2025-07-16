import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static const String _devApiUrl = 'http://localhost:8000';
  static const String _prodApiUrl = 'https://hestia-production.railway.app'; // Update with your Railway URL
  
  static String get apiBaseUrl {
    if (kDebugMode) {
      // Development mode
      return _devApiUrl;
    } else {
      // Production mode
      return _prodApiUrl;
    }
  }
  
  static String get apiUrl => '$apiBaseUrl/api';
  
  // API endpoints
  static String get mealsEndpoint => '$apiUrl/meals';
  static String get healthEndpoint => '$apiBaseUrl/health';
  
  // App settings
  static const String appName = 'Hestia';
  static const String appVersion = '0.1.0';
  
  // Feature flags
  static const bool enableDebugLogging = kDebugMode;
  static const bool enableAnalytics = !kDebugMode;
} 