import 'package:hive/hive.dart';
import 'package:password_manager/data/dao/add_password/add_password_dao.dart';
import 'package:password_manager/models/password_model.dart';
import 'package:password_manager/utils/constants.dart';

class AddPasswordDaoImpl extends AddPasswordDao {
  @override
  insertPassword(PasswordModel passwordModel) async{
    Box<PasswordModel> passwordBox =
        Hive.box<PasswordModel>(Constants.PASSWORD_DB);
    passwordBox.add(passwordModel);
  }

  @override
  Future<List<PasswordModel>> getPasswords() async{
    final passwords = Hive.box<PasswordModel>(Constants.PASSWORD_DB);
    List<PasswordModel> result = [];
    for (var i = 0; i < passwords.length; i++) {
      result.add(passwords.getAt(i));
    }
    return result;
  }
}
