

abstract class ShowPasswordEvent {}

class GetPasswordsEvent extends ShowPasswordEvent{}

class RearrangeListEvent extends ShowPasswordEvent{
  final passwords;

  RearrangeListEvent(this.passwords);
}



