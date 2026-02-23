import 'lib.dart';

void main() {
  bootstrap(
    const AppConfig(
      environment: AppEnvironment.dev,
      appName: 'PortalGun',
      baseUrl: 'https://dev.api.example.com',
      showDebugBanner: true,
      enableLogs: true,
    ),
  );
}
