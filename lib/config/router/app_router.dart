import 'package:go_router/go_router.dart';
import 'package:portal_gun/lib.dart';

final appRouter = GoRouter(
  // initialLocation: SplashPage.pathRoute,
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
                  path: CharacterDetailPage.pathRoute,
                  builder: (context, state) {
                    final rawId = state.pathParameters['id'];
                    final characterId = int.tryParse(rawId ?? '');
                    return CharacterDetailPage(characterId: characterId);
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
