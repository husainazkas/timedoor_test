import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../pages/home/home_page.dart';

final navKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: navKey,
  initialLocation: '/',
  routes: [GoRoute(path: '/', builder: (context, state) => const HomePage())],
);
