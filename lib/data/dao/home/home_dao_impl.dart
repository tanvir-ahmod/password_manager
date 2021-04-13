import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:password_manager/data/dao/home/home_dao.dart';
import 'package:password_manager/utils/constants.dart';

class HomeDaoImpl extends HomeDao {
  @override
  Future<String> getRootRandomKey() async {
    final storage = new FlutterSecureStorage();
    return await storage.read(key: Constants.RANDOM_KEY);
  }
}
