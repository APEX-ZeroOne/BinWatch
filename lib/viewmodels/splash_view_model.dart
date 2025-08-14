import 'package:flutter/material.dart';

class SplashViewModel extends ChangeNotifier {
  Future<void> init() async {
    await Future.delayed(const Duration(milliseconds: 900));
  }
}
