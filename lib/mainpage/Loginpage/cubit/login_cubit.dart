import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: '15124092057-37frav60b520ngp9oqpt7dktqqum2q2m.apps.googleusercontent.com',
  );



  // static const _storage = FlutterSecureStorage();

  Future<void> signIn(BuildContext context, String userType) async {
    emit(LoginIoading());

    try {
      print("🚫1. Starting Google Sign-In for userType: $userType");
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(LoginInitial()); // user canceled
        return;
      }

      print("🚫2. Getting authentication");
      final googleAuth = await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception("Google token missing");
      }

      print("🚫3. Calling backend API with userType: $userType");
      final response = await http.post(
        Uri.parse("https://a59ca78b6965.ngrok-free.app/api/employer/api/google-auth/"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "id_token": googleAuth.idToken,
          "email": googleUser.email,
          "username": googleUser.displayName ?? "",
          "access_token": googleAuth.accessToken,
        }),
      );

      print("🚫4. Response status: ${response.statusCode}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("🚫Response Body: $data");

        // await _storage.write(key: 'auth_token', value: data['token']);
        // await _storage.write(key: 'access_token', value: data['access']);
        // await _storage.write(key: 'refresh_token', value: data['refresh_token']);
        // await _storage.write(key: 'user_type', value: userType);
        // await _storage.write(key: 'user_email', value: googleUser.email);

        if (context.mounted) {
          _navigateBasedOnUserType(context, userType);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully signed in!'),
              backgroundColor: Colors.green,
            ),
          );
        }

        emit(LoginIoaded(
          name: googleUser.displayName ?? '',
          email: googleUser.email,
        ));
      } else {
        emit(LoginError('Server error: ${response.body}'));
      }
    } catch (e) {
      print("🚫 Authentication error: $e");
      emit(LoginError('Login failed: ${e.toString()}'));
    }
  }

  void _navigateBasedOnUserType(
      BuildContext context, String userType) {
    switch (userType.toLowerCase()) {
      case 'student':
        Navigator.of(context).pushReplacementNamed("DashBoard");
        break;
      case 'employer':
        Navigator.of(context).pushReplacementNamed("EmployerDashboard");
        break;
      case 'admin':
        Navigator.of(context).pushReplacementNamed("AdminDashboard");
        break;
      default:
        Navigator.of(context).pushReplacementNamed("OptionScreen");
        break;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    // await _storage.deleteAll();
    emit(LoginInitial());
  }
}
