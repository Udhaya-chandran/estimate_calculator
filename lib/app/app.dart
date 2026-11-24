import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class HardwareEstimationApp extends StatelessWidget {
  const HardwareEstimationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}

