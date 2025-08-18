import 'package:anjalim/intro_screens/splash/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthRepository _authRepository;

  SplashBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const SplashInitial()) {
    // Register event handlers
    on<SplashStarted>(_onSplashStarted);
    on<CheckAuthenticationStatus>(_onCheckAuthenticationStatus);
  }

  // Handle SplashStarted event
  Future<void> _onSplashStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    // Emit animating state
    emit(const SplashAnimating());

    // Wait for minimum splash duration (animations)
    await Future.delayed(const Duration(milliseconds: 2000));

    // Start checking authentication
    add(const CheckAuthenticationStatus());
  }

  // Handle CheckAuthenticationStatus event
  Future<void> _onCheckAuthenticationStatus(
    CheckAuthenticationStatus event,
    Emitter<SplashState> emit,
  ) async {
    try {
      emit(const SplashCheckingAuth());

      // Get authentication data from repository
      final authData = await _authRepository.getAuthData();

      if (authData != null) {
        // Check if token is valid
        if (_authRepository.isTokenValid(authData.accessToken)) {
          emit(SplashAuthenticated(userType: authData.userType));
        } else {
          await _authRepository.clearAuthData();
          emit(const SplashUnauthenticated());
        }
      } else {
        emit(const SplashUnauthenticated());
      }
    } catch (e) {
      emit(SplashError(message: e.toString()));
      // Navigate to welcome screen on error
      emit(const SplashUnauthenticated());
    }
  }
}
