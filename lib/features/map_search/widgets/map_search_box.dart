import 'package:flutter/material.dart';
import 'package:map_based_search_task/core/constants/palette.dart';
import 'package:map_based_search_task/core/shared_widgets/space_widget.dart';

class MapSearchBox extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback? onSubmit;

  const MapSearchBox(
      {super.key, required this.searchController, this.onSubmit});

  @override
  Widget build(BuildContext context) => Container(
        height: 55.0,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
            color: Palette.white,
            borderRadius: BorderRadius.circular(36.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 2)),
            ]),
        child: Row(
          children: [
            const Icon(Icons.search, color: Palette.orange),
            const SpaceWidget.horizontal(8.0),
            Expanded(
              child: TextField(
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: "What are you looking for, Layan?",
                  contentPadding: EdgeInsets.only(bottom: 8.0),
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Palette.grey),
                ),
              ),
            ),
            IconButton(
                onPressed: onSubmit,
                icon: Icon(Icons.map, color: Palette.grey)),
          ],
        ),
      );
}
