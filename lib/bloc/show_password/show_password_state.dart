import 'package:password_manager/models/password_model.dart';

abstract class ShowPasswordState {}

class GetPasswordState extends ShowPasswordState {
  List<PasswordModel> passwords;

  GetPasswordState(this.passwords);
}

class LoadingState extends ShowPasswordState {}

class RearrangedState extends ShowPasswordState {}
