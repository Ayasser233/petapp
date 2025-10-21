# Refresh Token Implementation Guide

## Overview
This app implements automatic token refresh functionality to maintain user sessions without requiring re-login when the access token expires.

## Architecture

### 1. Token Storage (`TokenService`)
Located in: `lib/core/services/token_service.dart`

**Features:**
- Securely stores both access tokens and refresh tokens using `flutter_secure_storage`
- Provides methods to save, retrieve, and clear tokens
- Methods:
  - `saveToken()` / `getToken()` - Access token management
  - `saveRefreshToken()` / `getRefreshToken()` - Refresh token management
  - `clearAllTokens()` - Clear both tokens on logout
  - `hasToken()` / `hasRefreshToken()` - Check token availability

### 2. Automatic Token Refresh (`ApiClient`)
Located in: `lib/core/services/api_client.dart`

**How it works:**

#### Interceptor Flow
```dart
Request → Add Auth Header → Check Connectivity → Make Request
                                                        ↓
                                               Response Code?
                                                        ↓
                                   ┌────────────────────┼────────────────────┐
                                   ↓                    ↓                    ↓
                              200 Success         401 Unauthorized     Other Errors
                                   ↓                    ↓                    ↓
                             Return Data      Refresh Token Flow    Error Handler
                                                        ↓
                                   ┌────────────────────┼────────────────────┐
                                   ↓                                         ↓
                           Refresh Success                           Refresh Failed
                                   ↓                                         ↓
                         Retry Original Request                    Clear Tokens & Logout
```

#### Key Features:
1. **401 Error Detection**: Automatically detects when access token expires
2. **Token Refresh**: Calls refresh token endpoint with stored refresh token
3. **Request Retry**: Retries the original failed request with new access token
4. **Concurrent Request Handling**: Prevents multiple simultaneous refresh requests
5. **Automatic Logout**: Logs out user if refresh token is invalid or expired

#### Implementation Details:
```dart
// Interceptor in api_client.dart
onError: (DioException error, handler) async {
  if (error.response?.statusCode == 401) {
    final newToken = await _refreshAccessToken();
    
    if (newToken != null) {
      // Retry request with new token
      error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
      final response = await _dio.request(...);
      return handler.resolve(response);
    } else {
      // Refresh failed - logout user
      await tokenService.clearAllTokens();
    }
  }
}
```

### 3. Authentication Service (`AuthService`)
Located in: `lib/core/services/auth_service.dart`

**Enhanced Features:**
- `hasValidSession()`: Checks if user has valid access or refresh token
- `tryRefreshToken()`: Checks if refresh token is available
- `init()`: On app startup, validates session using both tokens
- Automatic logout on token expiration

#### Session Validation Flow:
```dart
App Start → Check hasValidSession()
                    ↓
        ┌───────────┴───────────┐
        ↓                       ↓
    Has Token?           Has Refresh Token?
        ↓                       ↓
        └───────────┬───────────┘
                    ↓
            Set Authenticated
                    ↓
        First API Call → 401?
                    ↓
            Auto Refresh Token
                    ↓
        Continue Session
```

### 4. Token Response Handling
All authentication endpoints automatically extract and save tokens:

```dart
// In api_client.dart
Future<void> _handleTokenResponse(Response response) async {
  final accessToken = data['accessToken'] ?? data['access_token'];
  final refreshToken = data['refreshToken'] ?? data['refresh_token'];
  
  if (accessToken != null) {
    await tokenService.saveToken(accessToken);
  }
  
  if (refreshToken != null) {
    await tokenService.saveRefreshToken(refreshToken);
  }
}
```

## API Endpoints

### Refresh Token Endpoint
```dart
POST /api/v1/auth/refresh-token
Content-Type: application/json

{
  "refreshToken": "your-refresh-token-here"
}

// Response
{
  "accessToken": "new-access-token",
  "refreshToken": "new-refresh-token" // Optional: may rotate
}
```

## Token Flow Examples

### 1. Login Flow
```
User Login
    ↓
API: POST /auth/login
    ↓
Response: { accessToken, refreshToken, user }
    ↓
Save both tokens securely
    ↓
Set AuthStatus.authenticated
```

### 2. Protected API Call with Expired Token
```
API Request (with expired access token)
    ↓
401 Unauthorized Response
    ↓
Interceptor: Detect 401
    ↓
Get stored refresh token
    ↓
POST /auth/refresh-token
    ↓
Receive new access token
    ↓
Save new tokens
    ↓
Retry original request with new token
    ↓
Success: Return data to user
```

### 3. Token Refresh Failed
```
API Request (with expired access token)
    ↓
401 Unauthorized Response
    ↓
Attempt token refresh
    ↓
Refresh token also expired/invalid
    ↓
Clear all tokens
    ↓
Show "Session Expired" message
    ↓
Navigate to login screen
```

## Security Considerations

1. **Secure Storage**: Tokens stored using `flutter_secure_storage` with encryption
2. **Token Hiding**: Tokens never logged or displayed in UI
3. **Automatic Cleanup**: Tokens cleared on logout and failed refresh
4. **HTTPS Only**: All API calls must use HTTPS in production
5. **Token Rotation**: Backend can rotate refresh tokens for enhanced security

## Testing Scenarios

### Test 1: Normal Session
1. Login successfully
2. Make API calls (should work)
3. Verify tokens are stored

### Test 2: Access Token Expiry
1. Login successfully
2. Wait for access token to expire (or manually expire it)
3. Make API call
4. Should automatically refresh and succeed
5. Verify new tokens stored

### Test 3: Both Tokens Expired
1. Login successfully
2. Wait for both tokens to expire
3. Make API call
4. Should show session expired message
5. Should navigate to login
6. Verify tokens cleared

### Test 4: Concurrent Requests
1. Login successfully
2. Let access token expire
3. Make multiple simultaneous API calls
4. Should only refresh once
5. All requests should succeed

## Configuration

### Token Expiration Times (Backend)
- **Access Token**: 15 minutes (recommended)
- **Refresh Token**: 7 days (recommended)

### API Constants
Located in: `lib/core/utils/api_constants.dart`

```dart
class ApiConstants {
  static const String refreshTokenEndpoint = '/api/v1/auth/refresh-token';
  // ... other endpoints
}
```

## Troubleshooting

### Issue: Tokens not saving
**Check**: 
- `_handleTokenResponse()` is called after login/register
- Response contains `accessToken` and `refreshToken` fields
- `flutter_secure_storage` permissions configured

### Issue: Infinite refresh loop
**Check**:
- Refresh token endpoint doesn't require authentication
- `_isRefreshing` flag properly managed
- New Dio instance used for refresh (no interceptors)

### Issue: User logged out unexpectedly
**Check**:
- Refresh token not expired
- Backend returns 200 with valid tokens
- Network connectivity stable

## Future Enhancements

1. **Token Expiry Tracking**: Store token expiry time and refresh proactively
2. **Biometric Authentication**: Add fingerprint/face unlock for token access
3. **Multiple Device Support**: Backend tracks refresh tokens per device
4. **Silent Refresh**: Refresh before expiry without waiting for 401
5. **Token Revocation**: Backend endpoint to revoke all user tokens

## Code Locations

| Component | File Path |
|-----------|-----------|
| Token Service | `lib/core/services/token_service.dart` |
| API Client (Interceptor) | `lib/core/services/api_client.dart` |
| Auth Service | `lib/core/services/auth_service.dart` |
| Auth Cubit | `lib/features/auth/presentation/cubit/auth_cubit.dart` |
| Auth Repository | `lib/features/auth/data/repositories/auth_repository.dart` |
| Response Models | `lib/features/auth/data/models/auth_response_models.dart` |
| Request Models | `lib/features/auth/data/models/auth_request_models.dart` |

## Summary

✅ **Automatic token refresh** on 401 errors
✅ **Secure token storage** with flutter_secure_storage
✅ **Seamless user experience** - no interruption during refresh
✅ **Concurrent request handling** - prevents multiple refresh calls
✅ **Automatic logout** when refresh fails
✅ **Session validation** on app startup
✅ **Both tokens saved** on login/register/confirm email

The refresh token system ensures users stay authenticated without frequent logins while maintaining security through short-lived access tokens and long-lived refresh tokens.
