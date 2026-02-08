import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Service to handle social authentication (Google & Apple)
class SocialAuthService {
  static final SocialAuthService _instance = SocialAuthService._internal();
  factory SocialAuthService() => _instance;
  SocialAuthService._internal() {
    _initializeGoogleSignIn();
  }

  // IMPORTANT: For iOS, GoogleService-Info.plist handles the client ID automatically.
  // For Android, we need to specify the serverClientId (Web Client ID) for backend verification.
  // The serverClientId MUST match the OAuth 2.0 Web Client ID that your backend expects.
  late final GoogleSignIn _googleSignIn;

  void _initializeGoogleSignIn() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // For iOS, don't specify serverClientId - it will use the CLIENT_ID from GoogleService-Info.plist
      // and the backend should accept the iOS client ID
      _googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        // iOS will automatically use the CLIENT_ID from GoogleService-Info.plist
        // which is: 1017624066475-ntai924471ifb03p9v5g31i4kdf8g1tu.apps.googleusercontent.com
      );
    } else {
      // For Android, use the Web Client ID for backend verification
      _googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId: '1017624066475-bmilqqjo3k1qfivseeg1i85vjehtgo91.apps.googleusercontent.com',
      );
    }
  }

  /// Sign in with Google and return the ID token
  Future<String?> signInWithGoogle() async {
    try {
      debugPrint('🔐 Starting Google Sign-In...');
      debugPrint('📱 Platform: ${defaultTargetPlatform.name}');
      
      // Sign out first to ensure clean state (helps prevent iOS crashes)
      await _googleSignIn.signOut();
      debugPrint('🔄 Signed out previous session');
      
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
        throw Exception('Failed to get ID token from Google Sign-In');
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
      
      debugPrint('✅ Returning ID token successfully');
      return idToken;
    } on Exception catch (e) {
      debugPrint('❌ Google Sign-In exception: $e');
      debugPrint('❌ Exception type: ${e.runtimeType}');
      // Sign out to clean up state
      await _googleSignIn.signOut().catchError((_) => null);
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected Google Sign-In error: $e');
      debugPrint('❌ Error type: ${e.runtimeType}');
      // Sign out to clean up state
      await _googleSignIn.signOut().catchError((_) => null);
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
      final googleSignIn = _googleSignIn;
      await googleSignIn.signOut();
    } catch (e) {
      rethrow;
    }
  }

  /// Check if user is currently signed in with Google
  Future<bool> isSignedInWithGoogle() async {
    final googleSignIn = _googleSignIn;
    return googleSignIn.isSignedIn();
  }
}
