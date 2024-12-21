import 'package:map_based_search_task/features/map_search/models/location.dart';

abstract class LocationRepositoryInterface {
  Future<List<Location>> searchLocations(String searchTerm);
}
