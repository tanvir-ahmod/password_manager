import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/enter_password/enter_password_event.dart';
import 'package:password_manager/bloc/enter_password/enter_password_state.dart';
import 'package:password_manager/data/repositories/enter_password/enter_password_repository.dart';

class EnterPasswordBloc extends Bloc<EnterPasswordEvent, EnterPasswordState> {
  final EnterPasswordRepository _enterPasswordRepository;

  EnterPasswordBloc(this._enterPasswordRepository) : super(null);

  @override
  Stream<EnterPasswordState> mapEventToState(EnterPasswordEvent event) async* {
    if (event is CheckPasswordEvent) {
      bool isMasterPasswordCorrect =
      await _enterPasswordRepository.checkPasswordIfCorrect(event.password);
      yield CheckPasswordState(isMasterPasswordCorrect);
    }
  }
}
