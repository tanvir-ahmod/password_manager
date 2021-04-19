abstract class ChangeMasterPasswordEvent {}

class UpdateMasterPasswordEvent extends ChangeMasterPasswordEvent {
  final oldPassword;
  final newPassword;

  UpdateMasterPasswordEvent(this.oldPassword, this.newPassword);
}
