import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_pantry/features/authentication/data/models/user.dart';
import 'package:smart_pantry/features/recipes/data/models/recipe.dart';
import 'package:smart_pantry/presentation/screens/auth/forgot_password_screen.dart';
import 'package:smart_pantry/presentation/screens/auth/login_screen.dart';
import 'package:smart_pantry/presentation/screens/auth/signup_screen.dart';
import 'package:smart_pantry/presentation/screens/dashboard_screen.dart';
import 'package:smart_pantry/presentation/screens/pantry/pantry_list_screen.dart';
import 'package:smart_pantry/presentation/screens/pantry/pantry_scanner_screen.dart';
import 'package:smart_pantry/presentation/screens/profile/profile_screen.dart';
import 'package:smart_pantry/presentation/screens/recipes/recipe_detail_screen.dart';
import 'package:smart_pantry/presentation/screens/recipes/recipe_list_screen.dart';
import 'package:smart_pantry/presentation/screens/shopping/shopping_list_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

final authStateProvider = StreamProvider<AppUser?>((ref) {
  return firebase_auth.FirebaseAuth.instance.authStateChanges().map((user) {
    if (user == null) {
      return null;
    }
    return AppUser(
      id: user.uid,
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
    );
  });
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isAuthRoute = location == '/login' ||
          location == '/signup' ||
          location == '/forgot-password' ||
          location == '/splash';

      return authState.when(
        data: (user) {
          if (user == null) {
            return isAuthRoute || location == '/' ? null : '/login';
          }
          if (user != null && isAuthRoute) {
            return '/dashboard';
          }
          return null;
        },
        loading: () => location == '/' ? '/splash' : null,
        error: (_, __) => '/login',
      );
    },
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) {
          return authState.when(
            data: (user) => user == null ? '/login' : '/dashboard',
            loading: () => '/splash',
            error: (_, __) => '/login',
          );
        },
      ),
      _route('/splash', const SplashScreen()),
      _route('/login', const LoginScreen()),
      _route('/signup', const SignupScreen()),
      _route('/forgot-password', const ForgotPasswordScreen()),
      _route('/dashboard', const DashboardScreen()),
      _route('/pantry', const PantryListScreen()),
      _route('/pantry/scanner', const PantryScannerScreen()),
      _route('/recipes', const RecipeListScreen()),
      GoRoute(
        path: '/recipes/:recipeId',
        pageBuilder: (context, state) {
          final recipe = state.extra as Recipe?;
          return _page(state.pageKey, RecipeDetailScreen(recipe: recipe));
        },
      ),
      _route('/shopping', const ShoppingListScreen()),
      _route('/profile', const ProfileScreen()),
      _route('/profile/preferences', const ProfileScreen()),
    ],
  );
});

GoRoute _route(String path, Widget child) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) => _page(state.pageKey, child),
  );
}

CustomTransitionPage<void> _page(LocalKey key, Widget child) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.04, 0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
