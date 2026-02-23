import 'package:flutter/material.dart';
import 'package:portal_gun/lib.dart';

class PeakProFitApp extends StatelessWidget {
  const PeakProFitApp({super.key, required this.config});

  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: config.appName,
      debugShowCheckedModeBanner: config.showDebugBanner,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
