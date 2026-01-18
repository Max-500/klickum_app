import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:klicum/domain/entities/order.dart';
import 'package:klicum/domain/entities/raffle.dart';
import 'package:klicum/presentation/screens/address/select_address_screen.dart';
import 'package:klicum/presentation/screens/orders/order_screen.dart';
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

GoRouter getRouter(bool isAuth) => GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: isAuth ? '/' : SignInScreen.name,
  routes: [
    GoRoute(path: SignInScreen.name, pageBuilder: (context, state) => _buildFadePage(state, SignInScreen())),
    GoRoute(path: SignUpScreen.name,  pageBuilder: (context, state) => _buildFadePage(state, SignUpScreen())),
    GoRoute(path: '/raffle', pageBuilder: (context, state) => _buildFadePage(state, RaffeScreen(raffle: state.extra as Raffle))),
    GoRoute(path: '/select-address', pageBuilder: (context, state) => _buildFadePage(state, SelectAddressScreen(isFromCart: state.extra as bool))),
    GoRoute(path: CreateAddressScreen.name, pageBuilder: (context, state) => _buildFadePage(state, CreateAddressScreen())),
    GoRoute(path: '/order', pageBuilder: (context, state) => _buildFadePage(state, OrderScreen(order: state.extra as Order))),
    StatefulShellRoute.indexedStack(
      pageBuilder: (context, state, navigationShell) => _buildFadePage(state, MainView(navigationShell: navigationShell)),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/', builder: (context, state) => HomeView()),
          ]
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/reedem', builder: (context, state) => ReedemView()),
          ]
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/cart', builder: (context, state) => CartView()),
          ]
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/profile', builder: (context, state) => ProfileView()),
          ]
        ),
      ]
    )
  ]
);