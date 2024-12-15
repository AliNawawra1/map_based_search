import 'package:map_based_search_task/domain/entities/location.dart';

abstract class LocationRepositoryInterface {
  Future<List<Location>> fetchLocations(String searchTerm);
}
