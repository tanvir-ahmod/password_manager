import 'package:password_manager/models/password_model.dart';

abstract class PasswordManagerDao {
  insertPassword(PasswordModel passwordModel);
  Future<List<PasswordModel>> getPasswords();
  Future<bool> checkPasswordIfCorrect(String plainPassword);
}
