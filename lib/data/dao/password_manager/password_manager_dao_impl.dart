import 'package:hive/hive.dart';
import 'package:password_manager/data/dao/password_manager/password_manager_dao.dart';
import 'package:password_manager/models/password_model.dart';
import 'package:password_manager/models/password_model_with_index.dart';
import 'package:password_manager/utils/constants.dart';
import 'package:password_manager/utils/password_manager.dart';

class PasswordManagerDaoImpl extends PasswordManagerDao {
  static final PasswordManagerDaoImpl _passwordManagerDaoImpl =
      PasswordManagerDaoImpl._internal();

  factory PasswordManagerDaoImpl() {
    return _passwordManagerDaoImpl;
  }

  PasswordManagerDaoImpl._internal();

  @override
  Future<void> insertPassword(PasswordModel passwordModel) async {
    Box<PasswordModel> passwordBox =
        await Hive.openBox<PasswordModel>(Constants.PASSWORD_DB);
    String encryptedPassword = PasswordManager.encryptData(
        passwordModel.password,
        await PasswordManager.getMinimum32CharMasterPassword());
    passwordModel.password = encryptedPassword;
    passwordBox.add(passwordModel);
  }

  @override
  Future<List<PasswordModel>> getPasswords() async {
    final passwordBox =
        await Hive.openBox<PasswordModel>(Constants.PASSWORD_DB);
    return passwordBox.values.toList();
  }

  @override
  Future<bool> checkPasswordIfCorrect(String plainPassword) async {
    String decryptedMasterPassword =
        await PasswordManager.getDecryptedMasterPassword();
    return decryptedMasterPassword == plainPassword;
  }

  @override
  Future<void> saveMasterPassword(String password) async {
    await PasswordManager.saveMasterPassword(password);
  }

  @override
  Future<String> decryptPassword(String password) async {
    return PasswordManager.decryptData(
        password, await PasswordManager.getMinimum32CharMasterPassword());
  }

  @override
  Future<void> deletePassword(int index) async {
    final passwordBox =
        await Hive.openBox<PasswordModel>(Constants.PASSWORD_DB);
    passwordBox.deleteAt(index);
  }

  @override
  Future<void> updatePassword(
      PasswordModelWithIndex passwordModelWithIndex) async {
    final passwordBox =
        await Hive.openBox<PasswordModel>(Constants.PASSWORD_DB);
    final passwordModel = passwordModelWithIndex.passwordModel;
    String encryptedPassword = PasswordManager.encryptData(
        passwordModel.password,
        await PasswordManager.getMinimum32CharMasterPassword());
    passwordModel.password = encryptedPassword;
    passwordBox.putAt(passwordModelWithIndex.index, passwordModel);
  }

  @override
  Future<bool> updateMasterPassword(String oldPassword, String password) async {
    if (await checkPasswordIfCorrect(oldPassword)) {
      saveMasterPassword(password);
      return await Future.value(true);
    }
    return await Future.value(false);
  }

  @override
  Future<void> rearrangeList(List<PasswordModel> passwords) async {
    final passwordBox =
        await Hive.openBox<PasswordModel>(Constants.PASSWORD_DB);
    await passwordBox.clear();
    await passwordBox.addAll(passwords);
  }
}
