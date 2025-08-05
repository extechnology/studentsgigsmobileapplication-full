import 'package:flutter/material.dart';

abstract class GoogleAuthEvent {}

class GoogleSignInRequested extends GoogleAuthEvent {
  final BuildContext context;
  final String userType; // Add userType parameter

  GoogleSignInRequested(this.context, this.userType);
}
