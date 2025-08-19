import 'dart:convert';
import 'package:anjalim/student_Section/services/apiconstant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId:
        '15124092057-q7saopofjt97svqnsd47t12n7ckn29qi.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );

  // Update the signInWithGoogle method:
  static Future<Map<String, dynamic>?> signInWithGoogle(
      BuildContext context, String userType) async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception("Google token missing");
      }

      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}api/employee/api/google-auth/"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "id_token": googleAuth.idToken,
          "email": googleUser.email,
          "username": googleUser.displayName,
          "access_token": googleAuth.accessToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        const storage = FlutterSecureStorage();

        await Future.wait([
          storage.write(key: 'auth_token', value: data['token']),
          storage.write(key: 'access_token', value: data['access']),
          storage.write(key: 'refresh_token', value: data['refresh']),
          storage.write(key: 'user_type', value: userType),
          storage.write(key: 'user_email', value: googleUser.email),
          storage.write(key: 'is_logged_in', value: 'true'),
        ]);

        return data; // Just return data, don't navigate here
      } else {
        throw Exception("Server error: ${response.body}");
      }
    } catch (e) {
      throw Exception("Login failed: ${e.toString()}");
    }
  }

  // navigation based on user type
  static void _navigateBasedOnUserType(
      BuildContext context, String userType, Map<String, dynamic> userData) {
    switch (userType.toLowerCase()) {
      case 'student':
        Navigator.of(context).pushReplacementNamed("StudentHomeScreens");
        break;
      case 'employer':
        Navigator.of(context).pushReplacementNamed("EmployerDashboard");
        break;
      // case 'admin':
      //   Navigator.of(context).pushReplacementNamed("AdminDashboard");
      //   break;
      default:
        // Default navigation or onboarding
        Navigator.of(context).pushReplacementNamed("OptionScreen");
        break;
    }
  }

  // Method to sign out
  // static Future<void> signOut() async {
  //   try {
  //     await _googleSignIn.signOut();
  //     const storage = FlutterSecureStorage();
  //     await storage.deleteAll();
  //   } catch (e) {

  //   }
  // }
}
