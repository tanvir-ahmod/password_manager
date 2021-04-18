abstract class ShowDetailsEvent {}

class DecryptPasswordEvent extends ShowDetailsEvent {
  final password;

  DecryptPasswordEvent(this.password);
}
