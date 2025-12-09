import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:klicum/presentation/screens/screens.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

CustomTransitionPage _buildFadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (
      context,
      animation,
      secondaryAnimation,
      child
    ) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    }
  );
}


GoRouter getRouter() => GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: SignInScreen.name,
  routes: [
    GoRoute(path: SignInScreen.name, pageBuilder: (context, state) => _buildFadePage(state, SignInScreen())),
    GoRoute(path: SignUpScreen.name,  pageBuilder: (context, state) => _buildFadePage(state, SignUpScreen()))
  ]
);