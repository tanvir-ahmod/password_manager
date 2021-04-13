abstract class HomeState {}

class GetRootRandomKeyState extends HomeState {
  final rootRandomKey;

  GetRootRandomKeyState(this.rootRandomKey);
}
