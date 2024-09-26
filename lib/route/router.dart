import 'package:go_router/go_router.dart';

import '../view/color_scheme_view.dart';
import '../view/home_view.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (__, _) => const HomeView(),
    ),
    GoRoute(
      path: '/colorScheme',
      builder: (__, _) => const ColorSchemeExampleView(),
    ),
  ],
);
