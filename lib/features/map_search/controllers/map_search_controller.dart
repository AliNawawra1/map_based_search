import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_based_search_task/core/constants/asset_paths.dart';
import 'package:map_based_search_task/core/controllers/connectivity_controller.dart';
import 'package:map_based_search_task/core/utils/cache_manager.dart';
import 'package:map_based_search_task/core/utils/location_utils.dart';
import 'package:map_based_search_task/core/utils/navigation_services.dart';
import 'package:map_based_search_task/features/map_search/models/location.dart';
import 'package:map_based_search_task/features/map_search/models/location_data.dart';
import 'package:map_based_search_task/features/map_search/repositories/location_repository_impl.dart';
import 'package:map_based_search_task/features/map_search/repositories/location_repository_interface.dart';

class MapSearchController extends GetxController {
  final searchController = TextEditingController();
  final LocationRepositoryInterface locationRepository;
  final connectivityController = Get.find<ConnectivityController>();
  final mapController = Completer<GoogleMapController>();

  RxBool isLoading = false.obs;
  RxList<Marker> markers = RxList<Marker>();
  Timer? _timer;
  Rxn<String> mapStyle = Rxn<String>();

  MapSearchController() : locationRepository = LocationRepositoryImpl();

  @override
  void onInit() {
    super.onInit();
    _loadMapStyle();
  }

  Future<void> _loadMapStyle() async {
    try {
      mapStyle.value = await rootBundle.loadString(AssetPaths.mapStyle);
    } catch (e) {
      NavigationServices.showErrorSnackBar("Error loading map style: $e");
    }
  }

  /// Handles the location search logic.
  /// - Fetches locations based on the search term.
  /// - Updates the map view and markers.
  /// - Handles offline and empty result scenarios.
  Future<void> searchLocations(String searchTerm) async {
    isLoading.value = true;

    try {
      final locations = await _fetchLocations(searchTerm);

      connectivityController.isOffline.listen((offline) {
        if (offline) {
          CacheManager.saveToCache(locations.map((e) => e.toMap()).toList());
        }
      });

      if (locations.isNotEmpty && searchController.text.isNotEmpty) {
        _updateMapView(locations);
        _updateMarkers(locations);
      } else {
        _clearMarkers();
      }
    } catch (e) {
      NavigationServices.showErrorSnackBar(
          "Unable to fetch locations. Try again later.");
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches locations from the repository.
  /// Returns a list of `Location` objects based on the search term.
  Future<List<Location>> _fetchLocations(String searchTerm) async {
    if (connectivityController.isOffline.isTrue) {
      final cachedData = await CacheManager.readFromCache() ?? [];
      final filteredData =
          LocationUtils.filterLocations(cachedData, searchTerm);
      return LocationData.from(filteredData).data;
    }

    return locationRepository.fetchLocations(searchTerm);
  }

  /// Updates the map view to focus on the fetched locations.
  /// - If a single location is found, zoom in on it.
  /// - If multiple locations are found, adjust the map bounds to include all.
  Future<void> _updateMapView(List<Location> locations) async {
    if (locations.isEmpty) return;
    final controller = await mapController.future;
    LatLng coordinates = locations.length == 1
        ? LatLng(locations.first.latitude, locations.first.longitude)
        : _calculateBounds(locations).southwest;

    controller.animateCamera(CameraUpdate.newLatLngZoom(coordinates, 14.0));
  }

  void _updateMarkers(List<Location> locations) {
    markers.value =
        locations.map((location) => createCustomMarker(location)).toList();
  }

  Marker createCustomMarker(Location location) {
    return Marker(
      markerId: MarkerId(location.name),
      position: LatLng(location.latitude, location.longitude),
      infoWindow: InfoWindow(title: location.name),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
  }

  double _reduce(double a, double b) {
    return a < b ? a : b;
  }

  /// Calculates map bounds to include all the given locations.
  LatLngBounds _calculateBounds(List<Location> locations) {
    var lat = locations.map((loc) => loc.latitude).reduce(_reduce);
    var lng = locations.map((loc) => loc.longitude).reduce(_reduce);
    var latLngBounds = LatLng(lat, lng);

    return LatLngBounds(southwest: latLngBounds, northeast: latLngBounds);
  }

  /// Called when the user changes the search term in the input field.
  /// - Clears markers if the input is empty.
  /// - Initiates a search otherwise.
  void onChanged(String value) async {
    if (value.isEmpty) {
      markers.clear();
      (await mapController.future).animateCamera(CameraUpdate.zoomOut());
      return;
    }

    _timer?.cancel();
    _timer = Timer(
      Duration(milliseconds: 800),
      () => searchLocations(value),
    );
  }

  /// Set the map controller when the map is created
  void setMapController(GoogleMapController controller) {
    if (!mapController.isCompleted) {
      mapController.complete(controller);
    }
  }

  void _clearMarkers() {
    markers.clear();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
