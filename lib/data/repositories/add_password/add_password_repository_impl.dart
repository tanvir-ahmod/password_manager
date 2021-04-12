import 'package:password_manager/data/dao/add_password/add%20_password_dao_impl.dart';
import 'package:password_manager/data/repositories/add_password/add_password_repository.dart';
import 'package:password_manager/models/password_model.dart';

class AddPasswordRepositoryImpl extends AddPasswordRepository {
  final AddPasswordDaoImpl _addPasswordDao = AddPasswordDaoImpl();

  @override
  insertPassword(PasswordModel passwordModel) {
    _addPasswordDao.insertPassword(passwordModel);
  }

  @override
  Future getPasswords() => _addPasswordDao.getPasswords();
}
