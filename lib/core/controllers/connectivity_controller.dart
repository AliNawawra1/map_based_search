import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_based_search_task/core/services/navigation_services.dart';

class ConnectivityController extends GetxController {
  RxBool isOffline = false.obs;

  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _monitorConnectivity();
  }

  /// Monitor real-time connectivity changes
  void _monitorConnectivity() {
    _connectivity.onConnectivityChanged.listen((connectionResult) {
      if (!connectionResult.contains(ConnectivityResult.mobile) &&
          !connectionResult.contains(ConnectivityResult.wifi)) {
        isOffline.value = true;
        debugPrint("Device is offline.");
        NavigationServices.showErrorSnackBar(
            "Your internet is not available. Check your connection.");
      } else {
        isOffline.value = false;
        debugPrint("Device is online.");
        NavigationServices.showSuccessSnackBar("You're back online!");
      }
    });
  }
}
