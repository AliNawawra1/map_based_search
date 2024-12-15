import 'package:flutter/material.dart';
import 'package:map_based_search_task/core/constants/palette.dart';

class MapBottomNavigationBar extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int>? onTap;
  final Map<int, Map<String, dynamic>> navItems;

  const MapBottomNavigationBar({
    super.key,
    required this.navItems,
    required this.activeIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: activeIndex,
      onTap: onTap,
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
