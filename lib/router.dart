import 'package:audavis_time_management/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:audavis_time_management/presentation/pages/abscence_page.dart';
import 'package:audavis_time_management/presentation/pages/login_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter({required this.authCubit});

  final AuthCubit authCubit;

  GoRouter router() {
    return GoRouter(
      initialLocation: '/absence',
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
      redirect: (context, state) {
        final loggedIn = authCubit.state is LoggedIn;
        final goingToLogin = state.matchedLocation == '/login';

        if (!loggedIn) {
          return goingToLogin ? null : '/login';
        }

        if (goingToLogin) return '/absence';
        return null;
      },
      routes: [
        GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
        GoRoute(path: '/absence', builder: (_, __) => const AbscencePage()),
      ],
    );
  }
}
