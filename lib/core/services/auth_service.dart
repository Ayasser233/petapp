import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/services/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus { authenticated, unauthenticated, guest }

class AuthService extends GetxService {
  final TokenService _tokenService;
  
  // Observable auth status
  final Rx<AuthStatus> _authStatus = AuthStatus.unauthenticated.obs;
  
  AuthService({required TokenService tokenService}) 
      : _tokenService = tokenService;
  
  // Getter for auth status (reactive)
  AuthStatus get authStatus => _authStatus.value;
  
  // Getter for reactive auth status
  Rx<AuthStatus> get authStatusRx => _authStatus;
  
  // Stream to listen for auth changes
  Stream<AuthStatus> get authStateChanges => _authStatus.stream;
  
  // Initialize the auth service
  Future<AuthService> init() async {
    // Check if user has a token
    if (await _tokenService.hasToken()) {
      _authStatus.value = AuthStatus.authenticated;
    } else {
      // Check if user is in guest mode
      final prefs = await SharedPreferences.getInstance();
      final isGuest = prefs.getBool('isGuestMode') ?? false;
      
      _authStatus.value = isGuest 
          ? AuthStatus.guest 
          : AuthStatus.unauthenticated;
    }
    
    return this;
  }
  
  // Set guest mode
  Future<void> setGuestMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGuestMode', true);
    await prefs.setBool('isLoggedIn', false);
    await prefs.setBool('isOnboardingCompleted', true);
    _authStatus.value = AuthStatus.guest;
  }
  
  // Clear guest mode (used when logging in)
  Future<void> clearGuestMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGuestMode', false);
  }
  
  // Set authenticated state
  void setAuthenticated() {
    _authStatus.value = AuthStatus.authenticated;
  }
  
  // Set unauthenticated state
  Future<void> setUnauthenticated() async {
    await _tokenService.clearToken();
    _authStatus.value = AuthStatus.unauthenticated;
  }
  
  // Sign out user
  Future<void> signOut() async {
    await _tokenService.clearToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.setBool('isGuestMode', false);
    _authStatus.value = AuthStatus.unauthenticated;
  }
  
  // Check if user can access protected features
  bool canAccessProtectedFeature() {
    return _authStatus.value == AuthStatus.authenticated;
  }
  
  // Show login prompt dialog
  Future<bool> showLoginPrompt(BuildContext context) async {
    if (_authStatus.value == AuthStatus.authenticated) {
      return true;
    }
    
    // Return the result of the dialog (true if user chooses to login)
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text('You need to be logged in to use this feature.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: const Text('Login'),
          ),
        ],
      ),
    ) ?? false;
  }
}
