
import 'package:password_manager/models/password_model.dart';

abstract class AddPasswordEvent {}

class InsertPasswordEvent extends AddPasswordEvent{

  PasswordModel passwordModel;

  InsertPasswordEvent(this.passwordModel) : assert(passwordModel != null);
}


