import 'package:password_manager/data/dao/show_password/show%20_password_dao_impl.dart';
import 'package:password_manager/data/repositories/show_password/show_password_repository.dart';

class ShowPasswordRepositoryImpl extends ShowPasswordRepository {
  final ShowPasswordDaoImpl _showPasswordDao = ShowPasswordDaoImpl();

  @override
  Future getPasswords() => _showPasswordDao.getPasswords();
}
