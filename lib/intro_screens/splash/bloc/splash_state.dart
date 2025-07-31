import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

// Initial state when splash screen starts
class SplashInitial extends SplashState {
  const SplashInitial();
}

// State when animations are running
class SplashAnimating extends SplashState {
  const SplashAnimating();
}

// State when checking authentication
class SplashCheckingAuth extends SplashState {
  const SplashCheckingAuth();
}

// State when user is authenticated - navigate to dashboard
class SplashAuthenticated extends SplashState {
  final String userType;

  const SplashAuthenticated({required this.userType});

  @override
  List<Object> get props => [userType];
}

// State when user is not authenticated - navigate to welcome
class SplashUnauthenticated extends SplashState {
  const SplashUnauthenticated();
}

// State when an error occurs
class SplashError extends SplashState {
  final String message;

  const SplashError({required this.message});

  @override
  List<Object> get props => [message];
}
