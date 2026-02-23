import 'startup_result.dart';

abstract class AppStartupService {
  const AppStartupService();

  Future<StartupResult> run();
}
