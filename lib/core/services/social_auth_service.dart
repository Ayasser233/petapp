import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Service to handle social authentication (Google & Apple)
class SocialAuthService {
  static final SocialAuthService _instance = SocialAuthService._internal();
  factory SocialAuthService() => _instance;
  SocialAuthService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // Use the Web Client ID (OAuth 2.0 client) for backend verification
    serverClientId: '1017624066475-bmilqqjo3k1qfivseeg1i85vjehtgo91.apps.googleusercontent.com',
  );

  /// Sign in with Google and return the ID token
  Future<String?> signInWithGoogle() async {
    try {
      debugPrint('🔐 Starting Google Sign-In...');
      
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
        debugPrint('❌ Failed to get Google ID token');
        return null;
      }

      debugPrint('✅ Google ID token obtained');
      debugPrint('📝 Token preview: ${idToken.substring(0, 50)}...');
      
      return idToken;
    } catch (e) {
      debugPrint('❌ Error during Google Sign-In: $e');
      rethrow;
    }
  }

  /// Sign in with Apple and return the identity token
  Future<Map<String, String>?> signInWithApple() async {
    try {
      debugPrint('🍎 Starting Apple Sign-In...');

      // Check if Apple Sign In is available
      if (!await SignInWithApple.isAvailable()) {
        debugPrint('❌ Apple Sign-In not available on this device');
        throw Exception('Apple Sign-In is not available on this device');
      }

      // Request credential for the currently signed in Apple account
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      debugPrint('✅ Apple credentials obtained');

      // Return both identity token and authorization code
      return {
        'identityToken': credential.identityToken ?? '',
        'authorizationCode': credential.authorizationCode ?? '',
      };
    } catch (e) {
      debugPrint('❌ Error during Apple Sign-In: $e');
      rethrow;
    }
  }

  /// Sign out from Google
  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
      debugPrint('✅ Signed out from Google');
    } catch (e) {
      debugPrint('❌ Error signing out from Google: $e');
    }
  }

  /// Check if user is currently signed in with Google
  Future<bool> isSignedInWithGoogle() async {
    return _googleSignIn.isSignedIn();
  }
}
