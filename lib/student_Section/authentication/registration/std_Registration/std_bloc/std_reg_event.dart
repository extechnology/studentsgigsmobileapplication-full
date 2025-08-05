import 'package:flutter/material.dart';

abstract class RegisterEvent {}

class RegisterRequested extends RegisterEvent {
  final String email;
  final String username;
  final String password;
  final String confirmPassword;
  final BuildContext context;

  RegisterRequested({
    required this.email,
    required this.username,
    required this.password,
    required this.confirmPassword,
    required this.context,
  });
}

class SendOTPRequested extends RegisterEvent {
  final String email;
  final String username;
  final String password;
  final String confirmPassword;

  SendOTPRequested({
    required this.email,
    required this.username,
    required this.password,
    required this.confirmPassword,
  });
}

class VerifyOTPRequested extends RegisterEvent {
  final String email;
  final String otp;
  final String username;
  final String password;

  VerifyOTPRequested({
    required this.email,
    required this.otp,
    required this.username,
    required this.password,
  });
}

class ResendOTPRequested extends RegisterEvent {
  final String email;

  ResendOTPRequested({required this.email});
}
