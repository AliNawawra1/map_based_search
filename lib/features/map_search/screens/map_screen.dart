import 'package:flutter/material.dart';
import 'package:map_based_search_task/features/map_search/widgets/map_bottom_nav_bar.dart';
import 'package:map_based_search_task/features/map_search/widgets/map_screen_body.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      body: MapScreenBody(), bottomNavigationBar: MapBottomNavigationBar());
}
