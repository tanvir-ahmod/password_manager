import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:password_manager/bloc/add_password/add_password_bloc.dart';
import 'package:password_manager/bloc/change_master_password/change_master_password_bloc.dart';
import 'package:password_manager/bloc/enter_password/enter_password_bloc.dart';
import 'package:password_manager/bloc/setup_master_password/setup_master_password_bloc.dart';
import 'package:password_manager/bloc/show_details/show_details_bloc.dart';
import 'package:password_manager/bloc/show_password/show_password_bloc.dart';
import 'package:password_manager/data/repositories/home/home_repository_impl.dart';
import 'package:password_manager/data/repositories/manage_password/password_manager_repository_impl.dart';
import 'package:password_manager/models/password_model.dart';
import 'bloc/splash_screen/splash_screen_bloc.dart';
import 'utils/app_router.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<PasswordModel>(PasswordModelAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddPasswordBloc>(
          create: (context) => AddPasswordBloc(PasswordManagerRepositoryImpl()),
        ),
        BlocProvider<ShowPasswordBloc>(
          create: (context) =>
              ShowPasswordBloc(PasswordManagerRepositoryImpl()),
        ),
        BlocProvider<SplashScreenBloc>(
          create: (context) => SplashScreenBloc(HomeRepositoryImpl()),
        ),
        BlocProvider<EnterPasswordBloc>(
          create: (context) =>
              EnterPasswordBloc(PasswordManagerRepositoryImpl()),
        ),
        BlocProvider<SetupMasterPasswordBloc>(
          create: (context) =>
              SetupMasterPasswordBloc(PasswordManagerRepositoryImpl()),
        ),
        BlocProvider<ShowDetailsBloc>(
          create: (context) => ShowDetailsBloc(PasswordManagerRepositoryImpl()),
        ),
        BlocProvider<ChangeMasterPasswordBloc>(
          create: (context) =>
              ChangeMasterPasswordBloc(PasswordManagerRepositoryImpl()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Home',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: SplashRoute,
      ),
    );
  }
}
