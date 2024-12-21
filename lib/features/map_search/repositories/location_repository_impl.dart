import 'package:flutter/foundation.dart';
import 'package:map_based_search_task/core/constants/api_paths.dart';
import 'package:map_based_search_task/core/services/api_service.dart';
import 'package:map_based_search_task/core/utils/bloom_filter.dart';
import 'package:map_based_search_task/core/utils/lru_cache.dart';
import 'package:map_based_search_task/features/map_search/models/location.dart';
import 'package:map_based_search_task/features/map_search/repositories/map_location_repository_interface.dart';

class LocationRepository implements LocationRepositoryInterface {
  final _apiService = APIService();
  final LRUCache<String, List<Location>> _lruCache = LRUCache(10);
  final _bloomFilter = BloomFilter(size: 1000, hashFunctions: 3);

  @override
  Future<List<Location>> searchLocations(String searchTerm) async {
    /// Use Bloom Filter to check if the term might exist
    if (_bloomFilter.contains(searchTerm)) {
      debugPrint("Search term possibly exists, checking cache...");
      if (_lruCache.containsKey(searchTerm)) {
        return _lruCache.get(searchTerm)!;
      }
    } else {
      debugPrint(
          "Search term definitely does not exist, adding to Bloom Filter.");
      _bloomFilter.add(searchTerm);
    }

    /// Fetch from API as fallback
    try {
      final response = await _apiService
          .getRequest('${APIPaths.searchLocations}?item=$searchTerm');
      final results = _parseLocationResponse(response);

      _lruCache.set(searchTerm, results);
      return results;
    } catch (e) {
      debugPrint("Error searching data: $e");
      return [];
    }
  }

  List<Location> _parseLocationResponse(dynamic response) {
    final locations = response['locations'];
    if (locations is! List) return [];
    return locations.map((item) => Location.fromJson(item)).toList();
  }
}
