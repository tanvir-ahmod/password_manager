abstract class SetupMasterPasswordEvent {}

class SaveMasterPasswordEvent extends SetupMasterPasswordEvent {
  final password;

  SaveMasterPasswordEvent(this.password);
}
