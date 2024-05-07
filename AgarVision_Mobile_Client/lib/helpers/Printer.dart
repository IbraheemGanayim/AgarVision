import 'package:flutter/foundation.dart';

/// A utility class that provides a convenient way to print debug information
/// in Flutter.
class Printer {
  /// Prints the given [object] to the console if the `kDebugMode` constant is
  /// set to `true`.
  static void println(Object? object) {
    if (kDebugMode) {
      print(object);
    }
  }
}