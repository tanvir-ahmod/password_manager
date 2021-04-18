abstract class ShowDetailsEvent {}

class DecryptPasswordEvent extends ShowDetailsEvent {
  final password;

  DecryptPasswordEvent(this.password);
}

class DeleteDetailsEvent extends ShowDetailsEvent {
  final index;

  DeleteDetailsEvent(this.index);
}

class UpdateDetailsEvent extends ShowDetailsEvent {
  final passwordModelWithIndex;

  UpdateDetailsEvent(this.passwordModelWithIndex);
}
