import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/enter_password/enter_password_event.dart';
import 'package:password_manager/bloc/enter_password/enter_password_state.dart';
import 'package:password_manager/data/repositories/manage_password/password_manager_repository.dart';

class EnterPasswordBloc extends Bloc<EnterPasswordEvent, EnterPasswordState> {
  final PasswordManagerRepository _passwordManagerRepository;

  EnterPasswordBloc(this._passwordManagerRepository) : super(null);

  @override
  Stream<EnterPasswordState> mapEventToState(EnterPasswordEvent event) async* {
    if (event is CheckPasswordEvent) {
      bool isMasterPasswordCorrect =
      await _passwordManagerRepository.checkPasswordIfCorrect(event.password);
      yield CheckPasswordState(isMasterPasswordCorrect);
    }
  }
}
