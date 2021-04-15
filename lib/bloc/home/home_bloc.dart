import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/home/home_event.dart';
import 'package:password_manager/bloc/home/home_state.dart';
import 'package:password_manager/data/repositories/home/home_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc(this._homeRepository) : super(null);

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is GetRootRandomKeyEvent) {
      String rootRandomKey = await _homeRepository.getRootRandomKey();
      yield GetRootRandomKeyState(rootRandomKey);
    }
  }
}
