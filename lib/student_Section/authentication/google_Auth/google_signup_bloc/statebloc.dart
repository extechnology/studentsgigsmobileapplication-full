// statebloc.dart
abstract class GoogleAuthState {}

class GoogleAuthInitial extends GoogleAuthState {}

class GoogleAuthLoading extends GoogleAuthState {}

class GoogleAuthSuccess extends GoogleAuthState {
  final Map<String, dynamic> userData;
  GoogleAuthSuccess(this.userData);
}

class GoogleAuthFailure extends GoogleAuthState {
  final String error;
  GoogleAuthFailure(this.error);
}
