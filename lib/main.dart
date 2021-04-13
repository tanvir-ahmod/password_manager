import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:password_manager/bloc/add_password/add_password_bloc.dart';
import 'package:password_manager/bloc/show_password/show_password_bloc.dart';
import 'package:password_manager/data/repositories/add_password/add_password_repository_impl.dart';
import 'package:password_manager/data/repositories/home/home_repository_impl.dart';
import 'package:password_manager/data/repositories/show_password/show_password_repository_impl.dart';
import 'package:password_manager/models/password_model.dart';
import 'package:password_manager/utils/constants.dart';

import 'bloc/home/home_bloc.dart';
import 'utils/app_router.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<PasswordModel>(PasswordModelAdapter());
  await Hive.openBox<PasswordModel>(Constants.PASSWORD_DB);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddPasswordBloc>(
          create: (context) => AddPasswordBloc(AddPasswordRepositoryImpl()),
        ),
        BlocProvider<ShowPasswordBloc>(
          create: (context) => ShowPasswordBloc(ShowPasswordRepositoryImpl()),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(HomeRepositoryImpl()),
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
        initialRoute: HomeRoute,
      ),
    );
  }
}
