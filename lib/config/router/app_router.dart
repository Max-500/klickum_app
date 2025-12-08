import 'package:flutter/material.dart';
import 'package:klicum/presentation/screens/screens.dart';

class AppRouter {

  static const String initialRoute = '/sign-in';

  static Map<String, Widget Function(BuildContext context)> routes = {
    '/sign-in': (BuildContext context) => SignInScreen(),
    '/sign-up': (BuildContext context) => SignUpScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch(settings.name) {

    }

    return null;
  }

}