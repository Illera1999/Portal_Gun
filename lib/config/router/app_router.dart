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
    GoRoute(
      path: HomePage.pathRoute,
      builder: (context, state) => const HomePage(),
    ),
    // StatefulShellRoute.indexedStack(
    //   builder: (context, state, navigationShell) => Main,
    //   branches: [

    //   ]
    // )
  ],
);
