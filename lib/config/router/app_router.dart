import 'package:flutter/material.dart';

class AppRouter {

  static const String initialRoute = '/';

  static Map<String, Widget Function(BuildContext context)> routes = {
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch(settings.name) {

    }

    return null;
  }

}