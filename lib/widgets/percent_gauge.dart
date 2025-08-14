import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class PercentGauge extends StatelessWidget {
  final int percent;
  final String label;
  final bool compact;

  const PercentGauge({
    super.key,
    required this.percent,
    required this.label,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final danger = percent >= 90;
    final color = danger ? AppColors.danger : AppColors.accent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: compact ? 56 : 96,
          width: compact ? 56 : 96,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: percent / 100,
                strokeWidth: compact ? 6 : 10,
                color: color,
                backgroundColor: AppColors.card,
              ),
              Center(
                child: Text('$percent%',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: compact ? 12 : 16,
                      color: color,
                    )),
              )
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
              fontSize: compact ? 12 : 14,
            )),
      ],
    );
  }
}
