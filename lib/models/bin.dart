enum BinType { paper, can, plastic, general }

class BinInfo {
  final BinType type;
  final int percent; // 0~100
  const BinInfo({required this.type, required this.percent});

  String get label => switch (type) {
    BinType.paper => '종이',
    BinType.can => '캔',
    BinType.plastic => '패트',
    BinType.general => '일반쓰레기',
  };

  String get emoji => switch (type) {
    BinType.paper => '📄',
    BinType.can => '🥫',
    BinType.plastic => '🧴',
    BinType.general => '🗑️',
  };
}
