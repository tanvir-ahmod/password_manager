abstract class ShowDetailsState {}

class DecryptPasswordState extends ShowDetailsState {
  final password;

  DecryptPasswordState(this.password);
}

class DeleteDetailsState extends ShowDetailsState {}
