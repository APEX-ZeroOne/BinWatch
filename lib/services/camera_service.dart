class CameraService {
  // 실제 연결 시 카메라 퍼미션/프리뷰/추론 파이프라인을 붙이세요.
  Future<bool> openCamera() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}
