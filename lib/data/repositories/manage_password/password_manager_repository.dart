import 'package:password_manager/models/password_model.dart';

abstract class PasswordManagerRepository {
   insertPassword(PasswordModel passwordModel);

   Future getPasswords();

   Future checkPasswordIfCorrect(String plainPassword);
}
