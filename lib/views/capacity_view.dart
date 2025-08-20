import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../viewmodels/capacity_view_model.dart';
import '../widgets/bin_icon.dart';
import '../models/bin.dart';

class CapacityView extends StatelessWidget {
  const CapacityView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CapacityViewModel>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 90),
            const BinIcon(size: 120),
            const SizedBox(height: 90),

            // 네이비 영역
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                child: Column(
                  children: [
                    const Text(
                      '쓰레기통 용량',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 90),

                    // 2 x 2 그리드
                    Expanded(
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 24,
                          childAspectRatio: 0.94,
                        ),
                        itemCount: vm.bins.length,
                        itemBuilder: (_, i) {
                          final b = vm.bins[i];
                          final innerIcon = _innerIconFor(b.type);
                          final name = b.label;

                          return _BinCard(
                            name: name,
                            percent: b.percent,
                            innerIcon: innerIcon,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 카테고리별 내부 아이콘 결정
IconData _innerIconFor(BinType t) {
  switch (t) {
    case BinType.paper:
      return Icons.layers; // 종이
    case BinType.can:
      return Icons.local_drink_outlined; // 캔
    case BinType.plastic:
      return Icons.wash_outlined; // 페트
    case BinType.general:
      return Icons.delete_sweep; // 일반쓰레기
  }
}

/// 카드 위젯
class _BinCard extends StatelessWidget {
  final String name;
  final int percent;
  final IconData innerIcon;

  const _BinCard({
    required this.name,
    required this.percent,
    required this.innerIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 아이콘 영역
        SizedBox(
          height: 88,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 외곽 휴지통
              const BinIcon(size: 88, color: Colors.white),
              // 내부 아이콘
              Positioned(
                top: 30,
                child: Icon(
                  innerIcon,
                  color: const Color(0xFF86AAB7), // 연한 블루-그레이톤
                  size: 28,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // 이름
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),

        // 퍼센트
        Text(
          '$percent%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
