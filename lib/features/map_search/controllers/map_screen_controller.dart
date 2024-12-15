import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:map_based_search_task/core/constants/asset_paths.dart';
import 'package:map_based_search_task/features/map_search/controllers/base_map_controller.dart';
import 'package:map_based_search_task/core/utils/navigation_services.dart';

class MapScreenController extends BaseMapController {
  RxInt activeIndex = 1.obs;
  Rxn<String> mapStyle = Rxn<String>();

  final Map<int, Map<String, dynamic>> navItems = {
    0: {"icon": Icons.home_outlined, "label": ""},
    1: {"icon": Icons.search, "label": "Search"},
    2: {"icon": Icons.bookmark_outline, "label": ""},
    3: {"icon": Icons.person_outline, "label": ""},
  };

  MapScreenController();

  void changeIndex(int index) {
    activeIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    _loadMapStyle();
  }

  Future<void> _loadMapStyle() async {
    try {
      mapStyle.value = await rootBundle.loadString(AssetPaths.mapStyle);
    } catch (e) {
      emitError("Error loading map style: $e");
    }
  }

  void emitError(String message) {
    NavigationServices.showErrorSnackBar(message);
  }
}
