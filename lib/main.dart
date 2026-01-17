import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:klicum/config/router/app_router.dart';
import 'package:klicum/config/style/app_style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey = 'pk_test_51SgUge2HGsMzG2cQ0cHlS8lVIBfy9PJOBKCuDhghyfHr3LQG0qq7uanIcqEm4w6OZWoqvXctg1RA0R9b9mcK5p0700WFhK0YTY';
  await Stripe.instance.applySettings();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      routerConfig: getRouter()
    );
  }
}