import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class CacheManager {
  /// Path to the writable copy of `cache.json`
  static Future<String> getCacheFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/cache.json';
  }

  /// Save data to the writable copy of `cache.json`
  static Future<void> saveToCache(List<dynamic> newData) async {
    try {
      final filePath = await getCacheFilePath();
      final file = File(filePath);

      List<dynamic> cacheData = [];
      if (await file.exists()) {
        final content = await file.readAsString();
        cacheData = jsonDecode(content);
      }

      /// Remove duplicates: Keep only unique items
      final existingIds = cacheData.map((item) => item["name"]).toSet();
      final filteredNewData =
          newData.where((item) => !existingIds.contains(item["name"])).toList();

      cacheData.addAll(filteredNewData);

      /// Save the updated cache
      await file.writeAsString(jsonEncode(cacheData));
      debugPrint("Data saved to cache: $filePath");
    } catch (e) {
      debugPrint("Error saving to cache: $e");
    }
  }

  /// Read data from the writable copy of `cache.json`
  static Future<List<dynamic>?> readFromCache() async {
    try {
      final filePath = await getCacheFilePath();
      final file = File(filePath);

      if (await file.exists()) {
        final content = await file.readAsString();
        final cacheData = jsonDecode(content);
        return cacheData;
      } else {
        debugPrint("Cache file not found.");
        return null;
      }
    } catch (e) {
      debugPrint("Error reading from cache: $e");
      return null;
    }
  }
}
