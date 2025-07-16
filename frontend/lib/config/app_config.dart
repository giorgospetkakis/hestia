import 'package:flutter/foundation.dart';

class AppConfig {
  static const String _devApiUrl = 'http://localhost:8000';

  // Get the Railway domain from environment variable
  static String get _railwayDomain {
    const domain = String.fromEnvironment('RAILWAY_PUBLIC_DOMAIN',
        defaultValue: 'hestia-production-d51d.up.railway.app');
    return domain;
  }

  static String get apiBaseUrl {
    if (kDebugMode) {
      // Development mode
      return _devApiUrl;
    } else {
      // Production mode - use Railway domain from environment
      return 'https://$_railwayDomain';
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
