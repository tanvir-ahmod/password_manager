import 'package:password_manager/models/password_model.dart';

abstract class PasswordManagerRepository {
   Future<void> insertPassword(PasswordModel passwordModel);

   Future getPasswords();

   Future checkPasswordIfCorrect(String plainPassword);

   Future<void> saveMasterPassword(String password);


   Future<String> decryptPassword(String password);
}
