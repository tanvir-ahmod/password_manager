import 'package:password_manager/data/dao/enter_password/enter_password_dao.dart';
import 'package:password_manager/utils/password_manager.dart';

class EnterPasswordDaoImpl extends EnterPasswordDao {
  @override
  Future<bool> checkPasswordIfCorrect(String plainPassword) async {
    String decryptedMasterPassword =
        await PasswordManager.getDecryptedMasterPassword();
    return decryptedMasterPassword == plainPassword;
  }
}
