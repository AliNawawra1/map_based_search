import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:map_based_search_task/core/constants/api_paths.dart';
import 'package:map_based_search_task/core/controllers/connectivity_controller.dart';
import 'package:map_based_search_task/core/services/api_service.dart';
import 'package:map_based_search_task/core/utils/bloom_filter.dart';
import 'package:map_based_search_task/core/utils/lru_cache.dart';
import 'package:map_based_search_task/features/map_search/models/location.dart';
import 'package:map_based_search_task/features/map_search/repositories/location_repository_interface.dart';

class LocationRepositoryImpl implements LocationRepositoryInterface {
  final _apiService = APIService();
  final connectivityController = Get.find<ConnectivityController>();
  final falsePositiveRate = 0.01;
  late LRUCache<String, List<Location>> _cache;
  late BloomFilter _filter;
  bool _needsRetry = false;
  int expectedNumItems = 100;

  LocationRepositoryImpl() {
    _cache = LRUCache(expectedNumItems: expectedNumItems);
    _filter = BloomFilter(expectedNumItems: expectedNumItems);
    _initializeCaches();
    _listenToConnectivityChanges();
  }

  bool get cacheIsEmpty => _cache.isEmpty;

  /// Initialize caches
  Future<void> _initializeCaches() async {
    try {
      expectedNumItems = await _fetchLocationCount();

      if (expectedNumItems == 0) {
        expectedNumItems = 100;
        _needsRetry = true;
        return;
      }

      _cache = LRUCache(expectedNumItems: expectedNumItems);
      _filter = BloomFilter(expectedNumItems: expectedNumItems);

      _needsRetry = false;
      debugPrint(
          'Initialized BloomFilter and LRUCache with $expectedNumItems items.');
    } catch (e) {
      debugPrint('Error initializing caches: $e. Using default values.');
    }
  }

  /// Retry initialization when connection is restored
  void _listenToConnectivityChanges() {
    connectivityController.isOffline.listen((isOffline) async {
      if (!isOffline && _needsRetry) {
        debugPrint('Connection restored. Retrying cache initialization.');
        await _initializeCaches();
      }
    });
  }

  Future<int> _fetchLocationCount() async {
    try {
      final response = await _apiService.getRequest(APIPaths.locationsCount);

      if (response is Map<String, dynamic> &&
          response.containsKey(APIPaths.totalLocations)) {
        return response[APIPaths.totalLocations] as int;
      }

      return 0;
    } catch (e) {
      debugPrint('Error fetching location count: $e');
      return 0;
    }
  }

  @override
  Future<List<Location>> searchLocations(String searchTerm) async {
    /// Check Bloom Filter
    if (_filter.contains(searchTerm)) {
      if (_cache.containsKey(searchTerm)) {
        return _cache.get(searchTerm)!;
      }
    }

    /// Fetch from API as fallback
    try {
      final response = await _apiService
          .getRequest('${APIPaths.searchLocations}?item=$searchTerm');
      final results = _parseLocationResponse(response);

      if (results.isNotEmpty) {
        _filter.add(searchTerm);
        _cache.set(searchTerm, results);
      }

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
