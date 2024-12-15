import 'package:flutter/material.dart';
import 'package:map_based_search_task/features/map_search/controllers/map_screen_controller.dart';
import 'package:map_based_search_task/features/map_search/widgets/map_bottom_nav_bar.dart';
import 'package:map_based_search_task/features/map_search/widgets/map_screen_body.dart';

import 'package:get/get.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MapScreenController());

    return Obx(() => Scaffold(
          body: MapScreenBody(mapStyle: controller.mapStyle.value),
          bottomNavigationBar: MapBottomNavigationBar(
            activeIndex: controller.activeIndex.value,
            onTap: controller.changeIndex,
            navItems: controller.navItems,
          ),
        ));
  }
}
