import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:klicum/config/constants/helper.dart';
import 'package:klicum/config/constants/types.dart';
import 'package:klicum/config/router/app_router.dart';
import 'package:klicum/config/style/app_style.dart';
import 'package:klicum/presentation/providers/auth_provider.dart';
import 'package:klicum/presentation/providers/products_provider.dart';
import 'package:klicum/presentation/providers/raffles_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  Stripe.publishableKey = 'pk_test_51SgUge2HGsMzG2cQ0cHlS8lVIBfy9PJOBKCuDhghyfHr3LQG0qq7uanIcqEm4w6OZWoqvXctg1RA0R9b9mcK5p0700WFhK0YTY';
  await Stripe.instance.applySettings();
  runApp(ProviderScope(child: MyApp(isAuth: token != null)));
}

class MyApp extends ConsumerWidget {
  final bool isAuth;

  const MyApp({super.key, required this.isAuth});

  @override
  Widget build(BuildContext context, ref) {
    ref.listen<AuthStatus>(authProvider, (prev, next) async {
      if (next == AuthStatus.unauthenticated && prev != AuthStatus.unauthenticated) {
        ref.invalidate(raffleProvider);
        ref.invalidate(productProvider);
        await ref.read(raffleProvider.future);
        WidgetsBinding.instance.addPostFrameCallback((_) => Helper.handleTokenExpired());
      }
    });

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Klickum',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'PublicSans',
        colorSchemeSeed: AppStyle.primaryColor,
        scaffoldBackgroundColor: AppStyle.backgroundColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) return AppStyle.primaryColor.withValues(alpha: 0.8);
              return AppStyle.primaryColor;
            }),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
            elevation: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) return 2;
              return 4;
            })
          )
        ),
      ),
      routerConfig: getRouter(isAuth)
    );
  }
}