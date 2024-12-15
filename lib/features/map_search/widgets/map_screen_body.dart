import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_based_search_task/core/shared_widgets/offline_banner_widget.dart';
import 'package:map_based_search_task/core/shared_widgets/space_widget.dart';
import 'package:map_based_search_task/features/map_search/controllers/map_search_controller.dart';
import 'package:map_based_search_task/features/map_search/widgets/map_search_box.dart';
import 'package:map_based_search_task/features/map_search/widgets/map_view.dart';

class MapScreenBody extends StatelessWidget {
  final MapSearchController controller;
  final String? mapStyle;
  static const double lrPadding = 20.0;

  MapScreenBody({super.key, this.mapStyle})
      : controller = Get.put(MapSearchController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(
          () => GoogleMapView(
            markers: controller.markers.toSet(),
            mapStyle: mapStyle,
            onMapCreated: controller.setMapController,
          ),
        ),
        _buildSearchBox,
        _buildOfflineBanner,
      ],
    );
  }

  Widget get _buildSearchBox => Positioned(
        top: 50.0,
        left: lrPadding,
        right: lrPadding,
        child: MapSearchBox(
          searchController: controller.searchController,
          onChanged: controller.onChanged,
        ),
      );

  Widget get _buildOfflineBanner => Positioned(
        bottom: 10.0,
        left: lrPadding,
        right: lrPadding,
        child: Obx(() {
          if (controller.connectivityController.isOffline.value) {
            return OfflineBannerWidget();
          }

          return SpaceWidget.emptySpace();
        }),
      );
}
