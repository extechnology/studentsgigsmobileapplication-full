import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> logout(BuildContext context) async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    const secureStorage = FlutterSecureStorage();

    // Clear all stored tokens
    await secureStorage.delete(key: "access_token");
    await secureStorage.delete(key: "refresh_token");
    await secureStorage.deleteAll();

    // Sign out from Google
    await googleSignIn.disconnect();

    // Check if the widget is still mounted before using context
    if (!context.mounted) return;

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, "OptionScreen");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully')),
      );
    }
  } catch (e) {
    // print('Error during logout: $e');

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error during logout')),
      );
    }
  }
}
