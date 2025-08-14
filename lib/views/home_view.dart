import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../viewmodels/home_view_model.dart';
import '../widgets/bin_icon.dart';
import '../widgets/home_grid_tile.dart';
import '../widgets/percent_gauge.dart';
import '../models/bin.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            const BinIcon(size: 72),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.1),
                  children: [
                    // 카메라 보기
                    HomeGridTile(
                      onTap: () async {
                        final ok = await vm.openCamera();
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(ok ? '카메라 열림(Stub)' : '카메라 실패')),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('카메라 보기', style: _tileTitle),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset('assets/images/trash_sample.jpg', fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Center(child: Icon(Icons.settings_backup_restore_rounded, size: 18, color: AppColors.slate))
                        ],
                      ),
                    ),

                    // 분류 현황
                    HomeGridTile(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('분류 현황', style: _tileTitle),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Wrap(
                              spacing: 16, runSpacing: 10,
                              children: [
                                _chip('완료', Icons.layers),
                                _chip('완료', Icons.auto_delete_outlined),
                                _chip('완료', Icons.inventory_2_outlined),
                                _chip('미완료', Icons.delete_sweep, danger: true),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 쓰레기통 용량(요약)
                    HomeGridTile(
                      onTap: () => Navigator.pushNamed(context, '/capacity'),
                      color: AppColors.slate,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('쓰레기통 용량', style: _tileTitle.copyWith(color: Colors.white)),
                          const SizedBox(height: 12),
                          Expanded(
                            child: Center(
                              child: PercentGauge(percent: vm.overallFill, label: '전체 평균', compact: false),
                            ),
                          )
                        ],
                      ),
                    ),

                    // 에러 로그
                    HomeGridTile(
                      color: const Color(0xFF3E5D6E),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('에러 로그', style: _tileTitle.copyWith(color: Colors.white)),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListView.builder(
                              itemCount: vm.alerts.length,
                              itemBuilder: (_, i) {
                                final a = vm.alerts[i];
                                return Row(
                                  children: [
                                    Icon(Icons.warning_amber_rounded, size: 16,
                                        color: a.critical ? AppColors.danger : Colors.white70),
                                    const SizedBox(width: 6),
                                    Expanded(child: Text(a.message,
                                        style: const TextStyle(color: Colors.white, fontSize: 12))),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
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

  TextStyle get _tileTitle => const TextStyle(
      fontWeight: FontWeight.w800, color: AppColors.navy, fontSize: 16);

  Widget _chip(String text, IconData icon, {bool danger = false}) {
    return Chip(
      avatar: Icon(icon, size: 16, color: danger ? AppColors.danger : AppColors.navy),
      label: Text(text, style: TextStyle(
          fontWeight: FontWeight.w600,
          color: danger ? AppColors.danger : AppColors.navy)),
      backgroundColor: AppColors.card,
      side: BorderSide(color: danger ? AppColors.danger.withOpacity(.4) : Colors.transparent),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
