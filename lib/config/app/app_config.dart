import 'package:portal_gun/lib.dart';

class AppConfig {
  final AppEnvironment environment;
  final String appName;
  final String baseUrl;
  final bool showDebugBanner;
  final bool enableLogs;

  const AppConfig({
    required this.environment,
    required this.appName,
    required this.baseUrl,
    required this.showDebugBanner,
    required this.enableLogs,
  });
}
