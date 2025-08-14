import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class HomeGridTile extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? color;

  const HomeGridTile({
    super.key,
    required this.child,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.card;
    return Material(
      color: c,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: child,
        ),
      ),
    );
  }
}
