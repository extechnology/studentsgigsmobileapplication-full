import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class AuthRepository {
  final FlutterSecureStorage _secureStorage;

  AuthRepository({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  // Get authentication data
  Future<AuthData?> getAuthData() async {
    try {
      final accessToken = await _secureStorage.read(key: "access_token");
      final userType = await _secureStorage.read(key: "user_type");

      print("Retrieved data:");
      print("  - accessToken: $accessToken");
      print("  - userType: $userType");

      if (accessToken != null && userType != null) {
        return AuthData(
          accessToken: accessToken,
          userType: userType,
        );
      }
      return null;
    } catch (e) {
      print('Error getting auth data: $e');
      return null;
    }
  }

  // Validate JWT token
  bool isTokenValid(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        print("Invalid token format");
        return false;
      }

      final payload = parts[1];
      final normalizedPayload = base64Url.normalize(payload);
      final decodedPayload = utf8.decode(base64Url.decode(normalizedPayload));
      final payloadMap = json.decode(decodedPayload);

      final exp = payloadMap['exp'];
      if (exp == null) {
        print("No expiration claim in token");
        return false;
      }

      final expirationDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();

      print("Token expires at: $expirationDate");

      const bufferTime = Duration(minutes: 5);
      final isValid = now.isBefore(expirationDate.subtract(bufferTime));

      print("Token is ${isValid ? 'valid' : 'expired'}");
      return isValid;
    } catch (e) {
      print('Error validating JWT token: $e');
      return false;
    }
  }

  // Clear all authentication data
  Future<void> clearAuthData() async {
    try {
      await Future.wait([
        _secureStorage.delete(key: "access_token"),
        _secureStorage.delete(key: "refresh_token"),
        _secureStorage.delete(key: "auth_token"),
        _secureStorage.delete(key: "user_type"),
        _secureStorage.delete(key: "user_id"),
        _secureStorage.delete(key: "user_email"),
      ]);
      print("Authentication data cleared.");
    } catch (e) {
      print("Error clearing auth data: $e");
    }
  }
}

// Data model for authentication data
class AuthData {
  final String accessToken;
  final String userType;

  AuthData({
    required this.accessToken,
    required this.userType,
  });
}
