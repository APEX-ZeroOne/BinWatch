import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../viewmodels/home_view_model.dart';
import '../widgets/bin_icon.dart';
import 'dart:math' as math;

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4EFEB),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Expanded(
              flex: 4,
              child: Center(child: BinIcon(size: 72)),
            ),
            Expanded(
              flex: 6,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        _Tile(
                          color: Colors.white,
                          onTap: () => Navigator.pushNamed(context, '/camera'), // ← 추가
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              Text('카메라 보기', style: _title(AppColors.slate)),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Image.asset(
                                  'assets/images/camera_tile_img.jpg',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.slate.withOpacity(.7), width: 1.6),
                                ),
                                child: const Icon(Icons.camera_alt_outlined, size: 16, color: AppColors.slate),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        _Tile(
                          color: const Color(0xFFC7D9E5),
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              Text('분류 현황', style: _title(AppColors.navy)),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          _iconWithLabel(Icons.layers, '완료'),
                                          _iconWithLabel(Icons.auto_delete_outlined, '완료'),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          _iconWithLabel(Icons.inventory_2_outlined, '완료'),
                                          _iconWithLabel(Icons.delete_sweep, '미완료', dimmed: true),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _Tile(
                          color: const Color(0xFF304057),
                          onTap: () => Navigator.pushNamed(context, '/capacity'),
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              Text('쓰레기통 용량', style: _title(Colors.white)),
                              const Spacer(),
                              CapacityBin(
                                percent: math.min(1.0, math.max(0.0, vm.overallFill.toDouble())),
                                size: 86,
                                lowColor: const Color(0xFF64C27D),
                                midColor: const Color(0xFFF2C14E),
                                highColor: const Color(0xFFE57373),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${(vm.overallFill * 100).round()}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        _Tile(
                          color: const Color(0xFF577C8E),
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              Text('에러 로그', style: _title(Colors.white)),
                              const Spacer(),
                              const BinIcon(size: 76, color: Colors.white70),
                              const SizedBox(height: 10),
                              Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(.2),
                                  border: Border.all(color: Colors.white70, width: 1.5),
                                ),
                                child: const Center(
                                  child: Icon(Icons.error_outline, color: Colors.white, size: 16),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static TextStyle _title(Color color) => TextStyle(
    color: color,
    fontWeight: FontWeight.w800,
    fontSize: 16,
    letterSpacing: 1.2,
  );

  static Widget _iconWithLabel(IconData icon, String text, {bool dimmed = false}) {
    final Color c = dimmed ? AppColors.navy.withOpacity(.55) : AppColors.navy;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: c, size: 28),
        const SizedBox(height: 6),
        Text(text, style: TextStyle(color: c, fontWeight: FontWeight.w600, fontSize: 12)),
      ],
    );
  }
}

/// 꽉 채우는 공통 타일(간격 0)
class _Tile extends StatelessWidget {
  final Color color;
  final Widget child;
  final VoidCallback? onTap; // ← 추가

  const _Tile({required this.color, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: color,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// 휴지통 아이콘 내부가 아래에서 위로 채워지는 효과 + 용량에 따른 색상 단계
class CapacityBin extends StatelessWidget {
  final double percent; // 0.0 ~ 1.0
  final double size;
  final Color lowColor;   // 0% ~ 50%
  final Color midColor;   // 50% ~ 80%
  final Color highColor;  // 80% ~ 100%

  const CapacityBin({
    super.key,
    required this.percent,
    this.size = 80,
    required this.lowColor,
    required this.midColor,
    required this.highColor,
  });

  Color _fillColor(double p) {
    if (p < 0.5) return lowColor;
    if (p < 0.8) return midColor;
    return highColor;
  }

  @override
  Widget build(BuildContext context) {
    final p = percent.clamp(0.0, 1.0);
    final Color fill = _fillColor(p);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const BinIcon(size: 80, color: Colors.white30),
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [fill, fill, Colors.transparent, Colors.transparent],
                stops: [0.0, p, p, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcATop,
            child: const BinIcon(size: 80, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
