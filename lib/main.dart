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
        scaffoldBackgroundColor: AppStyle.backgroundColor
      ),
      routerConfig: getRouter()
    );
  }
}