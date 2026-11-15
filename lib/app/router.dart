import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:campus_lost_found/features/auth/application/auth_providers.dart';

abstract final class AppRoutes {
  static const splash = '/splash';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const verifyEmail = '/verify-email';
  static const home = '/home';
}

/// Re-runs the router redirect whenever the Firebase user changes,
/// including when email verification is completed.
class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh(Stream<User?> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<User?> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final repo = ref.watch(authRepositoryProvider);

  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: _AuthRefresh(repo.userChanges()),
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final location = state.matchedLocation;

      final isPublicRoute = location == AppRoutes.signIn ||
          location == AppRoutes.signUp;

      // Signed out: only public auth routes are allowed.
      if (user == null) {
        return isPublicRoute ? null : AppRoutes.signIn;
      }

      // Signed in but email not verified: must verify first.
      if (!user.emailVerified) {
        return location == AppRoutes.verifyEmail ? null : AppRoutes.verifyEmail;
      }

      // Signed in and verified: keep out of auth and verification screens.
      if (isPublicRoute ||
          location == AppRoutes.splash ||
          location == AppRoutes.verifyEmail) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      // Placeholder screens. Step 4 replaces each with the real design.
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const _PlaceholderScreen(title: 'Splash'),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const _PlaceholderScreen(title: 'Sign In'),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const _PlaceholderScreen(title: 'Sign Up'),
      ),
      GoRoute(
        path: AppRoutes.verifyEmail,
        builder: (context, state) =>
            const _PlaceholderScreen(title: 'Verify Email'),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const _PlaceholderScreen(title: 'Home'),
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(title)),
    );
  }
}