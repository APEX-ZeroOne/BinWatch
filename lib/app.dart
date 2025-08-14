import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_colors.dart';
import 'services/bin_service.dart';
import 'services/camera_service.dart';
import 'viewmodels/splash_view_model.dart';
import 'viewmodels/home_view_model.dart';
import 'viewmodels/capacity_view_model.dart';
import 'views/splash_view.dart';
import 'views/home_view.dart';
import 'views/capacity_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final binService = BinService();
    final cameraService = CameraService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel(binService, cameraService)),
        ChangeNotifierProvider(create: (_) => CapacityViewModel(binService)),
      ],
      child: MaterialApp(
        title: 'Smart Trash',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.cream,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accent),
          useMaterial3: true,
          fontFamily: 'NotoSansKR',
        ),
        routes: {
          '/': (_) => const SplashView(),
          '/home': (_) => const HomeView(),
          '/capacity': (_) => const CapacityView(),
        },
        initialRoute: '/',
      ),
    );
  }
}
