import 'package:password_manager/models/password_model.dart';

abstract class PasswordManagerDao {
  Future<void> insertPassword(PasswordModel passwordModel);
  Future<List<PasswordModel>> getPasswords();
  Future<bool> checkPasswordIfCorrect(String plainPassword);
  Future<void> saveMasterPassword(String password);
  Future<String> decryptPassword(String password);
}
