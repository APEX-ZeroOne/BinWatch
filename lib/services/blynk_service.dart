import 'dart:convert';
import 'package:http/http.dart' as http;

/// Blynk REST API에서 V5~V8 값을 가져오는 전용 서비스
/// 응답 예: {"V5":2182,"V6":635,"V7":1501,"V8":1037}
class BlynkService {
  final String baseUrl; // 예: https://blynk.cloud/external/api/get?token=...&V5&V6&V7&V8
  BlynkService(this.baseUrl);

  /// {"V5":..., "V6":..., "V7":..., "V8":...} 형태를 반환
  /// 값이 문자열/숫자 어떤 타입이든 그대로 담아줌 (뷰모델에서 숫자로 변환)
  Future<Map<String, dynamic>?> fetchV5toV8Map() async {
    final uri = Uri.parse(baseUrl);
    final res = await http.get(uri);
    if (res.statusCode != 200) return null;

    final body = res.body.trim();
    try {
      final decoded = json.decode(body);

      // 1) 정상적인 맵 응답
      if (decoded is Map) {
        final out = <String, dynamic>{};
        for (final k in const ['V5', 'V6', 'V7', 'V8']) {
          if (decoded.containsKey(k)) out[k] = decoded[k];
        }
        return out;
      }

      // 2) 혹시 배열로 올 때를 대비한 보조 처리: [v5, v6, v7, v8]
      if (decoded is List && decoded.length >= 4) {
        return {
          'V5': decoded[0],
          'V6': decoded[1],
          'V7': decoded[2],
          'V8': decoded[3],
        };
      }
    } catch (_) {
      // JSON 파싱 실패 시 null 반환
    }
    return null;
  }
}
