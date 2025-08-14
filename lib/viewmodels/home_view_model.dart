import 'package:flutter/material.dart';
import '../models/bin.dart';
import '../models/alert_item.dart';
import '../services/bin_service.dart';
import '../services/camera_service.dart';

class HomeViewModel extends ChangeNotifier {
  final BinService _binService;
  final CameraService _cameraService;
  List<BinInfo> bins = const [];
  List<AlertItem> alerts = const [];

  HomeViewModel(this._binService, this._cameraService) {
    bins = _binService.current;
    alerts = _binService.alerts;
    _binService.binStream.listen((list) {
      bins = list;
      notifyListeners();
    });
  }

  int get overallFill =>
      bins.isEmpty ? 0 : (bins.map((b) => b.percent).reduce((a,b)=>a+b) / bins.length).round();

  Future<bool> openCamera() => _cameraService.openCamera();
}
