import 'package:flutter/material.dart';
import 'package:map_based_search_task/core/constants/asset_paths.dart';
import 'package:map_based_search_task/core/utils/asset_loader.dart';
import 'package:map_based_search_task/domain/entities/location.dart';
import 'package:map_based_search_task/domain/entities/location_data.dart';
import 'package:map_based_search_task/domain/interfaces/location_repository_interface.dart';

class LocationRepository implements LocationRepositoryInterface {
  @override
  Future<List<Location>> fetchLocations(String searchTerm) async {
    try {
      /// Load JSON data from assets
      final mockLocations = await AssetLoader.loadJson(AssetPaths.mapData);

      /// Filter locations based on the search term
      final filteredLocations = _filterLocations(mockLocations, searchTerm);

      /// Convert filtered locations to entities
      return LocationData.from(filteredLocations).data;
    } catch (e) {
      debugPrint("Error fetching data: $e");
      return [];
    }
  }

  /// Filters locations based on the search term
  List<dynamic> _filterLocations(List<dynamic> locations, String searchTerm) {
    return locations.where((loc) {
      return loc["name"]!
          .toString()
          .toLowerCase()
          .contains(searchTerm.toLowerCase());
    }).toList();
  }
}
