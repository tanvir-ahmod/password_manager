abstract class EnterPasswordState {}

class CheckPasswordState extends EnterPasswordState{
  final isMasterPasswordCorrect;

  CheckPasswordState(this.isMasterPasswordCorrect);
}
