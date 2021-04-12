import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'password_model.g.dart';

@HiveType(typeId: 0)
class PasswordModel {
  @HiveField(0)
  String title;

  @HiveField(1)
  String userName;

  @HiveField(2)
  String password;

  PasswordModel({@required this.title, @required this.password, this.userName});
}
