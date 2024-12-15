import 'package:flutter/material.dart';
import 'package:map_based_search_task/core/constants/asset_paths.dart';
import 'package:map_based_search_task/core/utils/asset_loader.dart';
import 'package:map_based_search_task/core/utils/location_utils.dart';
import 'package:map_based_search_task/features/map_search/models/location.dart';
import 'package:map_based_search_task/features/map_search/models/location_data.dart';
import 'package:map_based_search_task/features/map_search/repositories/location_repository_interface.dart';

class LocationRepositoryImpl implements LocationRepositoryInterface {
  @override
  Future<List<Location>> fetchLocations(String searchTerm) async {
    try {
      /// Load JSON data from assets
      final mockLocations = await AssetLoader.loadJson(AssetPaths.mapData);

      /// Filter locations based on the search term
      final filteredLocations =
          LocationUtils.filterLocations(mockLocations, searchTerm);

      /// Convert filtered locations to models
      return LocationData.from(filteredLocations).data;
    } catch (e) {
      debugPrint("Error fetching data: $e");
      return [];
    }
  }
}
