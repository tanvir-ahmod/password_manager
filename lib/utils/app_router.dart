import 'package:flutter/material.dart';
import 'package:password_manager/ui/home.dart';

const String HomeRoute = "/";

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeRoute:
        return MaterialPageRoute(builder: (_) => Home());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
