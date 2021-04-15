import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/add_password/add_password_event.dart';
import 'package:password_manager/bloc/add_password/add_password_state.dart';
import 'package:password_manager/bloc/setup_master_password/setup_master_password_event.dart';
import 'package:password_manager/bloc/setup_master_password/setup_master_password_state.dart';
import 'package:password_manager/data/repositories/manage_password/password_manager_repository.dart';

class SetupMasterPasswordBloc
    extends Bloc<SetupMasterPasswordEvent, SetupMasterPasswordState> {
  final PasswordManagerRepository _passwordManagerRepository;

  SetupMasterPasswordBloc(this._passwordManagerRepository) : super(null);

  @override
  Stream<SetupMasterPasswordState> mapEventToState(
      SetupMasterPasswordEvent event) async* {
    if (event is SaveMasterPasswordEvent) {
      await _passwordManagerRepository.saveMasterPassword(event.password);
      yield MasterPasswordSetSate();
    }
  }
}
