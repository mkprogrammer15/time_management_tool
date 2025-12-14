import 'package:audavis_time_management/presentation/pages/abscence_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final navigatorKey = GlobalKey<NavigatorState>();
  static String currentRoute = '';
  String initialRouteFromNotification = '/';

  GoRouter router() => GoRouter(
    debugLogDiagnostics: kDebugMode,
    navigatorKey: navigatorKey,
    initialLocation: initialRouteFromNotification,
    routes: [
      GoRoute(path: '/', builder: (context, state) => const AbsenceScreen()),
    ],
  );
}
