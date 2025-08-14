import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class BinIcon extends StatelessWidget {
  final double size;
  final Color color;
  const BinIcon({super.key, this.size = 64, this.color = AppColors.accent});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.delete_outline, size: size, color: color.withOpacity(.9));
  }
}
