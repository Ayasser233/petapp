import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Service to handle social authentication (Google & Apple)
class SocialAuthService {
  static final SocialAuthService _instance = SocialAuthService._internal();
  factory SocialAuthService() => _instance;
  SocialAuthService._internal();

  // IMPORTANT: The serverClientId MUST match the OAuth 2.0 Web Client ID
  // that your backend is configured to verify. If you get "Wrong recipient" or
  // "payload audience != requiredAudience" errors, verify this ID matches
  // the backend configuration.
  // 
  // This should be the Web Client ID from Google Cloud Console, NOT the 
  // Android or iOS client ID.
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // Use the Web Client ID (OAuth 2.0 client) for backend verification
    // This MUST match the client ID configured in your backend
    // This is the client_type: 3 (Web) from your google-services.json
    serverClientId: '1017624066475-bmilqqjo3k1qfivseeg1i85vjehtgo91.apps.googleusercontent.com',
  );

  /// Sign in with Google and return the ID token
  Future<String?> signInWithGoogle() async {
    try {
      debugPrint('🔐 Starting Google Sign-In...');
      
      // Check if running on iOS without proper configuration
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        debugPrint('📱 Platform: iOS');
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        debugPrint('📱 Platform: Android');
      }
      
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        debugPrint('❌ Google Sign-In cancelled by user');
        return null;
      }

      debugPrint('✅ Google user signed in: ${googleUser.email}');

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Get the ID token
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        debugPrint('❌ ID token is null!');
        return null;
      }

      // Decode the token to see the audience claim (for debugging)
      try {
        final parts = idToken.split('.');
        if (parts.length == 3) {
          final payload = parts[1];
          // Add padding if needed
          var normalizedPayload = payload.replaceAll('-', '+').replaceAll('_', '/');
          while (normalizedPayload.length % 4 != 0) {
            normalizedPayload += '=';
          }
          final decoded = utf8.decode(base64.decode(normalizedPayload));
          final json = jsonDecode(decoded);
          debugPrint('📋 Token audience (aud): ${json['aud']}');
          debugPrint('📋 Token issuer (iss): ${json['iss']}');
          debugPrint('📧 Token email: ${json['email']}');
        }
      } catch (e) {
        debugPrint('⚠️  Failed to decode ID token for debugging: $e');
        // Don't throw here, token might still be valid
      }
      
      return idToken;
    } catch (e) {
      debugPrint('❌ Google Sign-In exception: $e');
      debugPrint('❌ Exception type: ${e.runtimeType}');
      throw Exception('Google Sign-In failed: $e');
    }
  }

  /// Sign in with Apple and return the identity token
  Future<Map<String, String>?> signInWithApple() async {
    try {

      // Check if Apple Sign In is available
      if (!await SignInWithApple.isAvailable()) {
        throw Exception('Apple Sign-In is not available on this device');
      }

      // Request credential for the currently signed in Apple account
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );


      // Return both identity token and authorization code
      return {
        'identityToken': credential.identityToken!,
        'authorizationCode': credential.authorizationCode,
      };
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out from Google
  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      rethrow;
    }
  }

  /// Check if user is currently signed in with Google
  Future<bool> isSignedInWithGoogle() async {
    return _googleSignIn.isSignedIn();
  }
}
