import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/show_password/show_password_event.dart';
import 'package:password_manager/bloc/show_password/show_password_state.dart';
import 'package:password_manager/data/repositories/show_password/show_password_repository.dart';
import 'package:password_manager/models/password_model.dart';

class ShowPasswordBloc extends Bloc<ShowPasswordEvent, ShowPasswordState> {
  final ShowPasswordRepository _showPasswordRepository;

  ShowPasswordBloc(this._showPasswordRepository) : super(null);

  @override
  Stream<ShowPasswordState> mapEventToState(ShowPasswordEvent event) async* {
    if (event is GetPasswordsEvent) {
      List<PasswordModel> passwords =
          await _showPasswordRepository.getPasswords();
      yield GetPasswordState(passwords);
    }
  }
}
