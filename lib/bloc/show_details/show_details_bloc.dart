import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/show_details/show_details_event.dart';
import 'package:password_manager/bloc/show_details/show_details_state.dart';
import 'package:password_manager/data/repositories/manage_password/password_manager_repository.dart';

class ShowDetailsBloc extends Bloc<ShowDetailsEvent, ShowDetailsState> {
  final PasswordManagerRepository _passwordManagerRepository;

  ShowDetailsBloc(this._passwordManagerRepository) : super(null);

  @override
  Stream<ShowDetailsState> mapEventToState(ShowDetailsEvent event) async* {
    if (event is DecryptPasswordEvent) {
      String decryptedPassword =
          await _passwordManagerRepository.decryptPassword(event.password);
      yield DecryptPasswordState(decryptedPassword);
    }
  }
}
