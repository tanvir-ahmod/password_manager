import 'package:password_manager/models/password_model.dart';

abstract class AddPasswordRepository {
   insertPassword(PasswordModel passwordModel);

   Future getPasswords();
}
