import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/splash_screen/splash_screen_event.dart';
import 'package:password_manager/bloc/splash_screen/splash_screen_state.dart';
import 'package:password_manager/data/repositories/home/home_repository.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  final HomeRepository _homeRepository;

  SplashScreenBloc(this._homeRepository) : super(null);

  @override
  Stream<SplashScreenState> mapEventToState(SplashScreenEvent event) async* {
    if (event is GetRootRandomKeyEvent) {
      String rootRandomKey = await _homeRepository.getRootRandomKey();
      yield GetRootRandomKeyState(rootRandomKey);
    }
  }
}
