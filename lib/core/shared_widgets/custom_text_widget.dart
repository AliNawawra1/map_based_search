import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  final String dataKey;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? fontColor;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final TextAlign? textAlign;

  const CustomTextWidget({
    super.key,
    required this.dataKey,
    this.fontSize,
    this.fontWeight,
    this.fontColor,
    this.textOverflow,
    this.maxLines,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      dataKey,
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: fontColor,
        overflow: textOverflow,
      ),
    );
  }
}
