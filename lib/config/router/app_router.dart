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
