import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_gun/lib.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: SplashPage.pathRoute,
  routes: [
    GoRoute(
      path: SplashPage.pathRoute,
      builder: (context, state) => const SplashPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShellPage(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: HomePage.pathRoute,
              builder: (context, state) => const HomePage(),
              routes: [
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: CharacterDetailPage.pathRoute,
                  redirect: (context, state) {
                    final rawId = state.pathParameters['id'];
                    final id = int.tryParse(rawId ?? '');
                    return id == null ? HomePage.pathRoute : null;
                  },
                  builder: (context, state) {
                    final id = int.parse(state.pathParameters['id']!);
                    return CharacterDetailPage(characterId: id);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AboutPage.pathRoute,
              builder: (context, state) => const AboutPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
