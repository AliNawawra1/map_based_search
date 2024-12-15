class LocationUtils {
  /// Filters a list of locations based on the search term.
  static List<dynamic> filterLocations(
      List<dynamic> locations, String searchTerm) {
    return locations.where((loc) {
      return loc["name"]!
          .toString()
          .toLowerCase()
          .contains(searchTerm.toLowerCase());
    }).toList();
  }
}
