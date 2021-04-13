import 'package:password_manager/models/password_model.dart';

abstract class HomeDao {
  Future<String> getRootRandomKey();
}
