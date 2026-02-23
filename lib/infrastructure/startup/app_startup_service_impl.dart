import 'package:portal_gun/lib.dart';

class AppStartupServiceImpl implements AppStartupService {
  const AppStartupServiceImpl({
    this.minimumSplashDuration = const Duration(seconds: 3),
  });

  final Duration minimumSplashDuration;

  @override
  Future<StartupResult> run() async {
    final splashDelay = Future<void>.delayed(minimumSplashDuration);

    await _initializeSession();

    await Future.wait([
      _loadLocalPreferences(),
      _loadRemoteConfig(),
      _warmUpCaches(),
    ]);

    await splashDelay;

    return const StartupResult(destination: HomePage.pathRoute);
  }

  Future<void> _initializeSession() async {
    // TODO: FirebaseAuth.currentUser / token local / secure storage
  }

  Future<void> _loadLocalPreferences() async {
    // TODO: SharedPreferences / flags locales
  }

  Future<void> _loadRemoteConfig() async {
    // TODO: Firebase Remote Config (si aplica)
  }

  Future<void> _warmUpCaches() async {
    // TODO: precarga minima (no datos pesados)
  }
}
