import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_based_search_task/core/controllers/connectivity_controller.dart';
import 'package:map_based_search_task/features/map_search/screens/map_screen.dart';

class AppRoot extends StatelessWidget {
  final ConnectivityController controller;

  AppRoot({super.key}) : controller = Get.put(ConnectivityController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(debugShowCheckedModeBanner: false, home: MapScreen());
  }
}
