import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/change_master_password/change_master_password_event.dart';
import 'package:password_manager/bloc/change_master_password/change_master_password_state.dart';
import 'package:password_manager/data/repositories/manage_password/password_manager_repository.dart';

class ChangeMasterPasswordBloc
    extends Bloc<ChangeMasterPasswordEvent, ChangeMasterPasswordState> {
  final PasswordManagerRepository _passwordManagerRepository;

  ChangeMasterPasswordBloc(this._passwordManagerRepository) : super(null);

  @override
  Stream<ChangeMasterPasswordState> mapEventToState(
      ChangeMasterPasswordEvent event) async* {
    if (event is UpdateMasterPasswordEvent) {
      bool isPasswordUpdated = await _passwordManagerRepository
          .updateMasterPassword(event.oldPassword, event.newPassword);
      yield UpdateMasterPasswordState(isPasswordUpdated);
    }
  }
}
