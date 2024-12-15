import 'package:flutter/material.dart';
import 'package:map_based_search_task/core/constants/palette.dart';

class MapBottomNavigationBar extends StatelessWidget {
  const MapBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<int, Map<String, dynamic>> navItems = {
      0: {"icon": Icons.home_outlined, "label": ""},
      1: {"icon": Icons.search, "label": "Search"},
      2: {"icon": Icons.bookmark_outline, "label": ""},
      3: {"icon": Icons.person_outline, "label": ""},
    };

    return BottomNavigationBar(
      currentIndex: 1,
      onTap: null,
      selectedItemColor: Palette.navSelectedColor,
      unselectedItemColor: Palette.navUnselectedColor,
      selectedLabelStyle: TextStyle(color: Palette.navUnselectedColor),
      type: BottomNavigationBarType.fixed,
      items: navItems.entries.map((entry) {
        final item = entry.value;
        return BottomNavigationBarItem(
          icon: Icon(item["icon"]),
          label: item["label"],
        );
      }).toList(),
    );
  }
}
