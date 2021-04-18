import 'package:password_manager/data/dao/password_manager/password_manager_dao_impl.dart';
import 'package:password_manager/data/repositories/manage_password/password_manager_repository.dart';
import 'package:password_manager/models/password_model.dart';

class PasswordManagerRepositoryImpl extends PasswordManagerRepository {
  static final PasswordManagerRepositoryImpl _passwordManagerRepositoryImpl =
      PasswordManagerRepositoryImpl._internal();

  factory PasswordManagerRepositoryImpl() {
    return _passwordManagerRepositoryImpl;
  }

  PasswordManagerRepositoryImpl._internal();

  final _passwordManagerDao = PasswordManagerDaoImpl();

  @override
  Future<void> insertPassword(PasswordModel passwordModel) =>
      _passwordManagerDao.insertPassword(passwordModel);

  @override
  Future getPasswords() => _passwordManagerDao.getPasswords();

  @override
  Future checkPasswordIfCorrect(plainPassword) =>
      _passwordManagerDao.checkPasswordIfCorrect(plainPassword);

  @override
  Future<void> saveMasterPassword(String password) =>
      _passwordManagerDao.saveMasterPassword(password);

  @override
  Future<String> decryptPassword(String password) => _passwordManagerDao.decryptPassword(password);
}
