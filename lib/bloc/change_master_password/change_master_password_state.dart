abstract class ChangeMasterPasswordState {}

class UpdateMasterPasswordState extends ChangeMasterPasswordState {
  final isSuccess;

  UpdateMasterPasswordState(this.isSuccess);
}
