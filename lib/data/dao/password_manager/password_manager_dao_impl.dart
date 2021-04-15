import 'package:hive/hive.dart';
import 'package:password_manager/data/dao/password_manager/password_manager_dao.dart';
import 'package:password_manager/models/password_model.dart';
import 'package:password_manager/utils/constants.dart';
import 'package:password_manager/utils/password_manager.dart';

class PasswordManagerDaoImpl extends PasswordManagerDao {

  static final PasswordManagerDaoImpl _passwordManagerDaoImpl = PasswordManagerDaoImpl._internal();

  factory PasswordManagerDaoImpl() {
    return _passwordManagerDaoImpl;
  }

  PasswordManagerDaoImpl._internal();

  @override
  insertPassword(PasswordModel passwordModel) async {
    Box<PasswordModel> passwordBox =
    Hive.box<PasswordModel>(Constants.PASSWORD_DB);
    passwordBox.add(passwordModel);
  }

  @override
  Future<List<PasswordModel>> getPasswords() async {
    final passwords = Hive.box<PasswordModel>(Constants.PASSWORD_DB);
    List<PasswordModel> result = [];
    for (var i = 0; i < passwords.length; i++) {
      result.add(passwords.getAt(i));
    }
    return result;
  }

  @override
  Future<bool> checkPasswordIfCorrect(String plainPassword) async {
    String decryptedMasterPassword =
    await PasswordManager.getDecryptedMasterPassword();
    return decryptedMasterPassword == plainPassword;
  }

  @override
  saveMasterPassword(String password) async{
    await PasswordManager.saveMasterPassword(password);
  }
}
