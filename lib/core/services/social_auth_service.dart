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
      // On iOS, do NOT set serverClientId — doing so causes idToken to be null.
      // The iOS client ID from GoogleService-Info.plist is used automatically.
      _googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );
    } else {
      // Android: serverClientId makes the token aud = web client ID ✓
      _googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId: '1017624066475-bmilqqjo3k1qfivseeg1i85vjehtgo91.apps.googleusercontent.com',
      );
    }
  }

  /// Sign in with Google and return the ID token string.
  Future<String?> signInWithGoogle() async {
    try {
      debugPrint('🔐 Starting Google Sign-In...');
      debugPrint('📱 Platform: ${defaultTargetPlatform.name}');

      await _googleSignIn.signOut();
      debugPrint('🔄 Signed out previous session');

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        debugPrint('❌ Google Sign-In cancelled by user');
        return null;
      }

      debugPrint('✅ Google user signed in: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      debugPrint('📋 idToken present: ${idToken != null}');

      if (idToken == null) {
        throw Exception('Failed to get ID token from Google Sign-In');
      }

      // Debug: decode token audience
      try {
        final parts = idToken.split('.');
        if (parts.length == 3) {
          var p = parts[1].replaceAll('-', '+').replaceAll('_', '/');
          while (p.length % 4 != 0) p += '=';
          final decoded = utf8.decode(base64.decode(p));
          final json = jsonDecode(decoded);
          debugPrint('📋 Token audience (aud): ${json['aud']}');
          debugPrint('📋 Token issuer (iss): ${json['iss']}');
          debugPrint('📧 Token email: ${json['email']}');
        }
      } catch (_) {}

      return idToken;
    } on Exception catch (e) {
      debugPrint('❌ Google Sign-In exception: $e');
      await _googleSignIn.signOut().catchError((_) => null);
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected Google Sign-In error: $e');
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
