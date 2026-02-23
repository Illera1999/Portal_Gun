import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portal_gun/lib.dart';

final providerAppConfig = Provider<AppConfig>(
  (ref) => throw UnimplementedError(),
);

Future<void> bootstrap(AppConfig appConfig) async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      overrides: [providerAppConfig.overrideWithValue(appConfig)],
      child: PeakProFitApp(config: appConfig),
    ),
  );
}
