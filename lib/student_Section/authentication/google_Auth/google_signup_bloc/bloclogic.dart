import 'package:anjalim/student_Section/authentication/google_Auth/google_signup_bloc/blocevent.dart';
import 'package:anjalim/student_Section/authentication/google_Auth/google_signup_bloc/statebloc.dart';
import 'package:anjalim/student_Section/authentication/google_Auth/googlesignup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoogleAuthBloc extends Bloc<GoogleAuthEvent, GoogleAuthState> {
  final GoogleAuthService repository;

  GoogleAuthBloc(this.repository) : super(GoogleAuthInitial()) {
    on<GoogleSignInRequested>((event, emit) async {
      emit(GoogleAuthLoading());
      try {
        final result = await GoogleAuthService.signInWithGoogle(
            event.context, event.userType);
        if (result != null) {
          emit(GoogleAuthSuccess(result));
        } else {
          emit(GoogleAuthFailure("Sign-in cancelled"));
        }
      } catch (e) {
        emit(GoogleAuthFailure(e.toString()));
      }
    });
  }
}
