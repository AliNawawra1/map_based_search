import 'dart:async';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_based_search_task/core/controllers/connectivity_controller.dart';
import 'package:map_based_search_task/data/repositories/location_repository.dart';
import 'package:map_based_search_task/domain/interfaces/location_repository_interface.dart';

abstract class BaseMapController extends GetxController {
  final LocationRepositoryInterface locationRepository;
  final mapController = Completer<GoogleMapController>();
  final connectivityController = Get.find<ConnectivityController>();

  BaseMapController() : locationRepository = LocationRepository();

  /// Set the map controller when the map is created
  void setMapController(GoogleMapController controller) {
    if (!mapController.isCompleted) {
      mapController.complete(controller);
    }
  }
}
