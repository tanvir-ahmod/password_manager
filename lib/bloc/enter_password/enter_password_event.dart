abstract class EnterPasswordEvent {}

class CheckPasswordEvent extends EnterPasswordEvent {
  final password;

  CheckPasswordEvent(this.password);
}
