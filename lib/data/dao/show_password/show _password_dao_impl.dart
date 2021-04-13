import 'package:hive/hive.dart';
import 'package:password_manager/data/dao/show_password/show_password_dao.dart';
import 'package:password_manager/models/password_model.dart';
import 'package:password_manager/utils/constants.dart';

class ShowPasswordDaoImpl extends ShowPasswordDao {


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
