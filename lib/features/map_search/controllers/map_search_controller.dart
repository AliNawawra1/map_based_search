import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_based_search_task/core/constants/asset_paths.dart';
import 'package:map_based_search_task/core/controllers/connectivity_controller.dart';
import 'package:map_based_search_task/core/services/navigation_services.dart';
import 'package:map_based_search_task/features/map_search/models/location.dart';
import 'package:map_based_search_task/features/map_search/repositories/location_repository_impl.dart';

class MapSearchController extends GetxController {
  final LocationRepositoryImpl locationRepository;
  final searchController = TextEditingController();
  final connectivityController = Get.find<ConnectivityController>();
  final mapController = Completer<GoogleMapController>();

  RxBool isLoading = false.obs;
  RxList<Marker> markers = RxList<Marker>();
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

  Future<void> searchLocations(String searchTerm) async {
    isLoading.value = true;

    try {
      final locations = await locationRepository.searchLocations(searchTerm);

      if (locations.isNotEmpty) {
        _updateMapView(locations);
        _updateMarkers(locations);
      } else {
        _clearMarkers();
        NavigationServices.showInfoSnackBar("No results for '$searchTerm'.");
      }
    } catch (e) {
      NavigationServices.showErrorSnackBar("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onSubmit() async {
    final searchTerm = searchController.text.trim();

    if (searchTerm.isEmpty || searchTerm.length < 3) {
      _clearMarkers();
      NavigationServices.showErrorSnackBar(
          "Search term must be at least 3 characters long.");
      return;
    }

    if (connectivityController.isOffline.value &&
        locationRepository.cacheIsEmpty) {
      NavigationServices.showErrorSnackBar(
          "Offline with no cached data. Please connect to search.");
      return;
    }

    await searchLocations(searchTerm);
  }

  /// Updates the map view to focus on the fetched locations.
  /// - If a single location is found, zoom in on it.
  /// - If multiple locations are found, adjust the map bounds to include all.
  Future<void> _updateMapView(List<Location> locations) async {
    if (locations.isEmpty) return;

    final controller = await mapController.future;

    if (locations.length == 1) {
      final singleLocation = LatLng(locations.first.lat, locations.first.lng);
      controller
          .animateCamera(CameraUpdate.newLatLngZoom(singleLocation, 14.0));
      return;
    }

    final bounds = _calculateBounds(locations);
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
  }

  void _updateMarkers(List<Location> locations) {
    markers.value = locations.map(createCustomMarker).toList();

    if (markers.isEmpty) return;

    Future.delayed(
        const Duration(milliseconds: 300),
        () async => (await mapController.future)
            .showMarkerInfoWindow(markers.first.markerId));
  }

  Marker createCustomMarker(Location location) {
    return Marker(
      markerId: MarkerId(location.name),
      position: LatLng(location.lat, location.lng),
      infoWindow: InfoWindow(title: location.name),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
  }

  /// Calculates map bounds to include all the given locations.
  LatLngBounds _calculateBounds(List<Location> locations) {
    double minLat = locations.map(_locationLat).reduce(_reduceMin);
    double minLng = locations.map(_locationLng).reduce(_reduceMin);
    double maxLat = locations.map(_locationLat).reduce(_reduceMax);
    double maxLng = locations.map(_locationLng).reduce(_reduceMax);

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  double _locationLat(Location loc) => loc.lat;

  double _locationLng(Location loc) => loc.lng;

  double _reduceMin(double a, double b) => a < b ? a : b;

  double _reduceMax(double a, double b) => a > b ? a : b;

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
