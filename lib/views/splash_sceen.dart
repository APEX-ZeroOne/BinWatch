import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // 2초 뒤 홈으로 이동 (예시: HomePage())
    Future.delayed(const Duration(seconds: 2), () {

    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.recycling, size: 80, color: Colors.greenAccent),
            SizedBox(height: 16),
            Text('BinWatch',
                style: TextStyle(fontSize: 32, color: Colors.white)),
            SizedBox(height: 8),
            Text('AI 기반 스마트 분리수거 시스템',
                style: TextStyle(color: Colors.white70)),
            SizedBox(height: 24),
            CircularProgressIndicator(color: Colors.greenAccent),
          ],
        ),
      ),
    );
  }
}
