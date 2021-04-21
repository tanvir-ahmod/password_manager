import 'package:flutter/material.dart';
import 'package:password_manager/models/password_model.dart';
import 'package:password_manager/models/password_model_with_index.dart';
import 'package:password_manager/ui/add_password.dart';
import 'package:password_manager/ui/change_master_password.dart';
import 'package:password_manager/ui/enter_master_password.dart';
import 'package:password_manager/ui/home.dart';
import 'package:password_manager/ui/setup_master_password.dart';
import 'package:password_manager/ui/show_details.dart';
import 'package:password_manager/ui/show_passwords.dart';
import 'package:password_manager/ui/splash_screen.dart';

const String SplashRoute = "/";
const String HomeRoute = "/home";
const String SetupMasterPasswordRoute = "/setupMasterPassword";
const String EnterMasterPasswordRoute = "/enterMasterPassword";
const String AddPasswordRoute = "/addMasterPassword";
const String ShowPasswordsRoute = "/showPassword";
const String ShowDetailsRoute = "/showDetails";
const String ChangeMasterPasswordRoute = "/changeMasterPassword";

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashRoute:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case HomeRoute:
        return MaterialPageRoute(builder: (_) => Home());
      case SetupMasterPasswordRoute:
        return MaterialPageRoute(builder: (_) => SetupMasterPassword());
      case EnterMasterPasswordRoute:
        return MaterialPageRoute(builder: (_) => EnterMasterPassword());
      case AddPasswordRoute:
        return MaterialPageRoute(builder: (_) => AddPassword());
      case ShowPasswordsRoute:
        return MaterialPageRoute(builder: (_) => ShowPasswords());
      case ShowDetailsRoute:
        var passwordModelWithIndex =
            settings.arguments as PasswordModelWithIndex;
        return MaterialPageRoute(
            builder: (_) =>
                ShowDetails(passwordModelWithIndex: passwordModelWithIndex));
      case ChangeMasterPasswordRoute:
        return MaterialPageRoute(builder: (_) => ChangeMasterPassword());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
