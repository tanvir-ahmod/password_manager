import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/show_password/show_password_event.dart';
import 'package:password_manager/bloc/show_password/show_password_state.dart';
import 'package:password_manager/data/repositories/manage_password/password_manager_repository.dart';
import 'package:password_manager/models/password_model.dart';

class ShowPasswordBloc extends Bloc<ShowPasswordEvent, ShowPasswordState> {
  final PasswordManagerRepository _passwordManagerRepository;

  ShowPasswordBloc(this._passwordManagerRepository) : super(null);

  @override
  Stream<ShowPasswordState> mapEventToState(ShowPasswordEvent event) async* {
    if (event is GetPasswordsEvent) {
      List<PasswordModel> passwords =
          await _passwordManagerRepository.getPasswords();
      yield GetPasswordState(passwords);
    }
  }
}
