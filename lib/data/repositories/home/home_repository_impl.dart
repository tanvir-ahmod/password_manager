import 'package:password_manager/data/dao/home/home_dao_impl.dart';
import 'package:password_manager/data/repositories/home/home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {
  final HomeDaoImpl _homeDao = HomeDaoImpl();

  @override
  Future getRootRandomKey() => _homeDao.getRootRandomKey();
}
