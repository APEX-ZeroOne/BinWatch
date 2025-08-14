import 'dart:async';
import '../models/bin.dart';
import '../models/alert_item.dart';

class BinService {
  // 주기적으로 용량 업데이트가 온다고 가정
  final _controller = StreamController<List<BinInfo>>.broadcast();

  BinService() {
    // 더미 스트림
    _tick();
  }

  Stream<List<BinInfo>> get binStream => _controller.stream;

  List<BinInfo> _snapshot = const [
    BinInfo(type: BinType.paper, percent: 35),
    BinInfo(type: BinType.can, percent: 80),
    BinInfo(type: BinType.plastic, percent: 70),
    BinInfo(type: BinType.general, percent: 98),
  ];

  List<BinInfo> get current => _snapshot;

  // 알림 더미
  List<AlertItem> get alerts => [
    AlertItem(time: DateTime.now().subtract(const Duration(minutes: 12)),
        message: '일반쓰레기통이 90%를 초과했습니다.', critical: true),
    AlertItem(time: DateTime.now().subtract(const Duration(hours: 3)),
        message: '캔 분리수거 완료'),
  ];

  void _tick() async {
    // 10초마다 약간의 변화
    while (true) {
      await Future.delayed(const Duration(seconds: 10));
      _snapshot = _snapshot.map((e) {
        final d = (e.percent + ([-2,-1,0,1,2]..shuffle()).first)
            .clamp(0, 100);
        return BinInfo(type: e.type, percent: d);
      }).toList();
      _controller.add(_snapshot);
    }
  }

  void dispose() => _controller.close();
}
