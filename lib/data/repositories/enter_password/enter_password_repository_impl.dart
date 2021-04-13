import 'package:password_manager/data/dao/enter_password/enter%20_password_dao_impl.dart';
import 'package:password_manager/data/repositories/enter_password/enter_password_repository.dart';

class EnterPasswordRepositoryImpl extends EnterPasswordRepository {
  final _enterPasswordDao = EnterPasswordDaoImpl();

  @override
  Future checkPasswordIfCorrect(plainPassword) => _enterPasswordDao.checkPasswordIfCorrect(plainPassword);
}
