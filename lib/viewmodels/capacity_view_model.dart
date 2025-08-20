import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/bin.dart';
import '../services/blynk_service.dart';

class CapacityViewModel extends ChangeNotifier {
  final BlynkService _blynk;
  Timer? _timer;

  // 물리 파라미터
  static const double binDepthCm = 20.0;     // 통 깊이
  static const double sensorOffsetCm = 5.0;  // 센서가 위로 5cm
  static const double emptyDist = binDepthCm + sensorOffsetCm; // 25cm
  static const double fullDist  = sensorOffsetCm;              // 5cm

  List<BinInfo> bins = const [
    BinInfo(type: BinType.paper,   percent: 0),
    BinInfo(type: BinType.can,     percent: 0),
    BinInfo(type: BinType.plastic, percent: 0),
    BinInfo(type: BinType.general, percent: 0),
  ];

  CapacityViewModel(this._blynk) {
    _refresh();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _refresh());
  }

// lib/viewmodels/capacity_view_model.dart

  Future<void> _refresh() async {
    try {
      final map = await _blynk.fetchV5toV8Map(); // {"V5":2182,"V6":"635",...} 어떤 타입이든 올 수 있음
      if (map == null || map.isEmpty) return;

      // 무엇이 오든 double로 변환
      double _toDouble(dynamic v) {
        if (v is num) return v.toDouble();
        if (v is String) return double.tryParse(v) ?? 0.0;
        return 0.0;
      }

      int toPctFromRaw(dynamic raw) {
        final cm = _valueToCm(_toDouble(raw));
        final dd = cm.clamp(fullDist, emptyDist);
        final ratio = (emptyDist - dd) / binDepthCm; // 0..1
        return (ratio * 100).clamp(0, 100).round();
      }

      final pPaper   = toPctFromRaw(map['V5']);
      final pCan     = toPctFromRaw(map['V6']);
      final pPlastic = toPctFromRaw(map['V7']);
      final pGeneral = toPctFromRaw(map['V8']);

      bins = [
        BinInfo(type: BinType.paper,   percent: pPaper),
        BinInfo(type: BinType.can,     percent: pCan),
        BinInfo(type: BinType.plastic, percent: pPlastic),
        BinInfo(type: BinType.general, percent: pGeneral),
      ];
      notifyListeners();
    } catch (_) {
      // 네트워크/파싱 에러는 조용히 무시 (이전 값 유지)
    }
  }


  /// 단위 추정 → cm로 변환
  /// - 값이 100보다 크면 보통 mm/10 단위로 오는 경우가 많아 /10
  ///   예) 635 → 63.5cm, 2182 → 218.2cm(→ 클램프되어 0%)
  double _valueToCm(double v) {
    if (v > 100) return v / 10.0; // mm(또는 mm*?) → cm 추정
    return v; // 이미 cm라고 가정
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
