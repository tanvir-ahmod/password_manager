import 'package:flutter/material.dart';
import 'package:password_manager/ui/enter_master_password.dart';
import 'package:password_manager/ui/home.dart';
import 'package:password_manager/ui/setup_master_password.dart';

const String HomeRoute = "/";
const String SetupMasterPasswordRoute = "/setupMasterPassword";
const String EnterMasterPasswordRoute = "/enterMasterPassword";

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeRoute:
        return MaterialPageRoute(builder: (_) => Home());
      case SetupMasterPasswordRoute:
        return MaterialPageRoute(builder: (_) => SetupMasterPassword());
      case EnterMasterPasswordRoute:
        return MaterialPageRoute(builder: (_) => EnterMasterPassword());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
