import 'package:flutter/material.dart';
import '../models/bin.dart';
import '../services/bin_service.dart';

class CapacityViewModel extends ChangeNotifier {
  final BinService _service;
  List<BinInfo> bins = const [];

  CapacityViewModel(this._service) {
    bins = _service.current;
    _service.binStream.listen((e) {
      bins = e;
      notifyListeners();
    });
  }
}
