import 'lib.dart';

void main() {
  bootstrap(
    const AppConfig(
      environment: AppEnvironment.prod,
      appName: 'PortalGun',
      baseUrl: 'https://api.example.com',
      showDebugBanner: false,
      enableLogs: false,
    ),
  );
}
