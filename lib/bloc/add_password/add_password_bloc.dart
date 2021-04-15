import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/add_password/add_password_event.dart';
import 'package:password_manager/bloc/add_password/add_password_state.dart';
import 'package:password_manager/data/repositories/manage_password/password_manager_repository.dart';

class AddPasswordBloc extends Bloc<AddPasswordEvent, AddPasswordState> {
  final PasswordManagerRepository _passwordManagerRepository;

  AddPasswordBloc(this._passwordManagerRepository) : super(null);

  @override
  Stream<AddPasswordState> mapEventToState(AddPasswordEvent event) async* {
    if (event is InsertPasswordEvent) {
      await _passwordManagerRepository.insertPassword(event.passwordModel);
      yield PasswordSavedState();
    }
  }
}
