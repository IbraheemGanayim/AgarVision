import 'package:flutter/foundation.dart';

/// Contains application-level constants.
class AppConstants {
  /// Returns the base URL for API requests.
  static String get baseUrl {
    // If the application is in debug mode, return the localhost URL.
    if (kDebugMode) return "http://localhost:5000";

    // Otherwise, return the production URL.
    return "https://agarvision-api-51eb828e9bf5.herokuapp.com";
  }
}