import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klicum/config/router/app_router.dart';
import 'package:klicum/config/style/app_style.dart';

void main() {
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
        )
      ),
      routerConfig: getRouter()
    );
  }
}