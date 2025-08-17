import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import '../core/theme/app_colors.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  //local streaming
  static const String streamUrl = 'http://192.168.137.236:8080/stream';

  @override
  void initState() {
    super.initState();
    HttpOverrides.global = _AllowBadCert();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.navy,
        title: const Text('카메라 스트리밍',
            style: TextStyle(fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Mjpeg(
              isLive: true,
              stream: streamUrl,       // MJPEG 주소
              timeout: const Duration(seconds: 10),
              error: (ctx, err, st) => Container(
                color: Colors.black12,
                alignment: Alignment.center,
                child: Text(
                  '스트림을 불러올 수 없습니다.\n$err',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AllowBadCert extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback = (cert, host, port) => true;
    return client;
  }
}
