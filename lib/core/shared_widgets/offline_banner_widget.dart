import 'package:flutter/material.dart';
import 'package:map_based_search_task/core/shared_widgets/custom_text_widget.dart';

class OfflineBannerWidget extends StatelessWidget {
  const OfflineBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 40.0),
      decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8.0)),
      child: const CustomTextWidget(
        dataKey: "You're offline. Showing cached data.",
        fontColor: Colors.white,
        textAlign: TextAlign.center,
      ),
    );
  }
}
