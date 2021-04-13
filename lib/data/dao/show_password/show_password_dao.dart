import 'package:password_manager/models/password_model.dart';

abstract class ShowPasswordDao {
  Future<List<PasswordModel>> getPasswords();
}
