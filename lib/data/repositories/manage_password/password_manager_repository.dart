import 'package:password_manager/models/password_model.dart';
import 'package:password_manager/models/password_model_with_index.dart';

abstract class PasswordManagerRepository {
  Future<void> insertPassword(PasswordModel passwordModel);

  Future getPasswords();

  Future checkPasswordIfCorrect(String plainPassword);

  Future<void> saveMasterPassword(String password);

  Future<String> decryptPassword(String password);

  Future<void> deletePassword(int index);

  Future<void> updatePassword(PasswordModelWithIndex passwordModelWithIndex);

  Future<bool> updateMasterPassword(String oldPassword, String newPassword);
}
