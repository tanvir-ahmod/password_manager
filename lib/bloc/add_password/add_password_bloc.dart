import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/add_password/add_password_event.dart';
import 'package:password_manager/bloc/add_password/add_password_state.dart';
import 'package:password_manager/data/repositories/add_password/add_password_repository.dart';

class AddPasswordBloc extends Bloc<AddPasswordEvent, AddPasswordState> {
  final AddPasswordRepository _addPasswordRepository;

  AddPasswordBloc(this._addPasswordRepository) : super(null);

  @override
  Stream<AddPasswordState> mapEventToState(AddPasswordEvent event) async* {
    if (event is InsertPasswordEvent) {
      await _addPasswordRepository.insertPassword(event.passwordModel);
      yield PasswordSavedState();
    }
  }
}
