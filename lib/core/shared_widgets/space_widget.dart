import 'package:flutter/widgets.dart';

class SpaceWidget extends StatelessWidget {
  final double width;
  final double height;

  const SpaceWidget(double vSpace, {super.key})
      : width = 0,
        height = vSpace;

  const SpaceWidget.horizontal(double hSpace, {super.key})
      : width = hSpace,
        height = 0;

  const SpaceWidget.vertical(double vSpace, {super.key})
      : width = 0,
        height = vSpace;

  const SpaceWidget.emptySpace({super.key})
      : width = 0,
        height = 0;

  @override
  Widget build(BuildContext context) {
    if (width == 0 && height == 0) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: width,
      height: height,
    );
  }
}
