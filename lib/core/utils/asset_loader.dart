import 'dart:convert';
import 'package:flutter/services.dart';

class AssetLoader {
  /// Loads JSON data from assets
  static Future<List<dynamic>> loadJson(String path) async {
    try {
      final String response = await rootBundle.loadString(path);
      return jsonDecode(response);
    } catch (e) {
      throw Exception("Error loading JSON from $path: $e");
    }
  }
}
