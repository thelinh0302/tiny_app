import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:finly_app/core/constants/app_images.dart';

/// Renders an icon that can be an asset path or a network URL (png/svg).
Widget buildCategoryIcon(
  String src, {
  double width = 54,
  double height = 54,
  BoxFit fit = BoxFit.contain,
}) {
  final lower = src.toLowerCase();
  if (src.startsWith('http')) {
    if (lower.endsWith('.svg')) {
      return SvgPicture.network(src, width: width, height: height, fit: fit);
    }
    return Image.network(src, width: width, height: height, fit: fit);
  }
  // Asset fallback (supports .svg via AppImages helper)
  return AppImages.image(src, width: width, height: height, fit: fit);
}
