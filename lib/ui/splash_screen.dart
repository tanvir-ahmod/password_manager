import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/splash_screen/splash_screen_bloc.dart';
import 'package:password_manager/bloc/splash_screen/splash_screen_event.dart';
import 'package:password_manager/bloc/splash_screen/splash_screen_state.dart';
import 'package:password_manager/utils/app_router.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1500),
        () => BlocProvider.of<SplashScreenBloc>(context).add(GetRootRandomKeyEvent()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashScreenBloc, SplashScreenState>(
      listener: (context, state) {
        if (state is GetRootRandomKeyState &&
            (state.rootRandomKey != null && !state.rootRandomKey.isEmpty)) {
          Navigator.pushNamedAndRemoveUntil(
              context, EnterMasterPasswordRoute, (r) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(context, HomeRoute, (r) => false);
        }
      },
      child: Scaffold(
          body: Center(
        child: Image.asset(
          "assets/images/lock_icon.png",
        ),
      )),
    );
  }
}
