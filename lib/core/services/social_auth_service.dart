import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Service to handle social authentication (Google & Apple)
class SocialAuthService {
  static final SocialAuthService _instance = SocialAuthService._internal();
  factory SocialAuthService() => _instance;
  SocialAuthService._internal();

  bool _initialized = false;

  /// Must be called once before any Google Sign-In operations.
  /// Safe to call multiple times — subsequent calls are no-ops.
  Future<void> initializeGoogleSignIn() async {
    if (_initialized) return;
    _initialized = true;

    if (defaultTargetPlatform == TargetPlatform.android) {
      // Android: serverClientId makes idToken audience = web client ID ✓
      await GoogleSignIn.instance.initialize(
        serverClientId:
            '1017624066475-bmilqqjo3k1qfivseeg1i85vjehtgo91.apps.googleusercontent.com',
      );
    } else {
      // iOS: client ID is read automatically from GoogleService-Info.plist
      await GoogleSignIn.instance.initialize();
    }
  }

  /// Sign in with Google and return the ID token string.
  Future<String?> signInWithGoogle() async {
    try {
      await initializeGoogleSignIn();

      debugPrint('🔐 Starting Google Sign-In...');
      debugPrint('📱 Platform: ${defaultTargetPlatform.name}');

      // Sign out any previous session first
      await GoogleSignIn.instance.signOut();
      debugPrint('🔄 Signed out previous session');

      // v7: authenticate() replaces signIn(); pass scopes as scopeHint
      final GoogleSignInAccount googleUser =
          await GoogleSignIn.instance.authenticate(
        scopeHint: ['email', 'profile'],
      );

      debugPrint('✅ Google user signed in: ${googleUser.email}');

      // v7: authentication is a synchronous getter — no await needed
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

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
    } on GoogleSignInException catch (e) {
      debugPrint('❌ Google Sign-In exception [${e.code}]: ${e.description}');
      await GoogleSignIn.instance.signOut().catchError((_) {});
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected Google Sign-In error: $e');
      await GoogleSignIn.instance.signOut().catchError((_) {});
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

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

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
      await GoogleSignIn.instance.signOut();
    } catch (e) {
      rethrow;
    }
  }

  /// Check if a Google session can be restored silently.
  /// In v7, isSignedIn() is removed — use attemptLightweightAuthentication().
  Future<bool> isSignedInWithGoogle() async {
    try {
      await initializeGoogleSignIn();
      final account =
          await GoogleSignIn.instance.attemptLightweightAuthentication();
      return account != null;
    } catch (_) {
      return false;
    }
  }
}