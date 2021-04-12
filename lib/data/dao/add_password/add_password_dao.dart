import 'package:password_manager/models/password_model.dart';

abstract class AddPasswordDao {
  insertPassword(PasswordModel passwordModel);
  Future<List<PasswordModel>> getPasswords();
}
