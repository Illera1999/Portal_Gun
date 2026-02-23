import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portal_gun/lib.dart';

final providerAppStartupService = Provider<AppStartupService>(
  (ref) => const AppStartupServiceImpl(),
);

final providerStartup = FutureProvider<StartupResult>((ref) async {
  final startupService = ref.read(providerAppStartupService);
  return startupService.run();
});
