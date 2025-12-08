import 'package:flutter/material.dart';
import 'package:klicum/presentation/screens/auth/sign_up_screen.dart';

class AppRouter {

  static const String initialRoute = '/sign-up';

  static Map<String, Widget Function(BuildContext context)> routes = {
    '/sign-up': (BuildContext context) => SignUpScreen()
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch(settings.name) {

    }

    return null;
  }

}