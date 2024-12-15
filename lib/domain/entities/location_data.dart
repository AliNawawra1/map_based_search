import 'package:map_based_search_task/core/utils/json_utils.dart';
import 'package:map_based_search_task/domain/entities/location.dart';

class LocationData {
  List<Location> data;

  LocationData._(this.data);

  factory LocationData.from(List<dynamic> data) {
    return LocationData._(JsonUtils.jsonToList(data, Location.fromMap));
  }
}