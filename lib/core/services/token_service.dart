import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  final FlutterSecureStorage _storage;
  
  TokenService({FlutterSecureStorage? storage}) 
      : _storage = storage ?? const FlutterSecureStorage();
  
  // Access Token methods
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }
  
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }
  
  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }
  
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Refresh Token methods
  Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }
  
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }
  
  Future<void> clearRefreshToken() async {
    await _storage.delete(key: _refreshTokenKey);
  }
  
  Future<bool> hasRefreshToken() async {
    final token = await getRefreshToken();
    return token != null && token.isNotEmpty;
  }

  // Clear all tokens
  Future<void> clearAllTokens() async {
    await Future.wait([
      clearToken(),
      clearRefreshToken(),
    ]);
  }
}