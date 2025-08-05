import 'package:flutter/material.dart';

abstract class LoginEvent {}

class LoginRequested extends LoginEvent {
  final String username;
  final String password;
  final BuildContext context;

  LoginRequested({
    required this.username,
    required this.password,
    required this.context,
  });
}
