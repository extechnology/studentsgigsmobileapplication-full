import 'package:equatable/equatable.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object> get props => [];
}

// Event to start the splash screen process
class SplashStarted extends SplashEvent {
  const SplashStarted();
}

// Event to check authentication status
class CheckAuthenticationStatus extends SplashEvent {
  const CheckAuthenticationStatus();
}
