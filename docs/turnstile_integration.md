# Cloudflare Turnstile Integration Guide

## Overview
This guide explains how to implement Cloudflare Turnstile token generation for login and registration in your Flutter app.

## What is Cloudflare Turnstile?
Turnstile is Cloudflare's CAPTCHA alternative that provides bot protection without annoying users. It generates tokens that your backend validates to ensure requests are from legitimate users.

## Setup Instructions

### 1. Get Your Turnstile Site Key

1. Go to [Cloudflare Dashboard](https://dash.cloudflare.com/)
2. Navigate to **Turnstile** section
3. Create a new site or use existing one
4. Copy your **Site Key** (public key)
5. Your backend will need the **Secret Key** (keep it secure!)

### 2. Configure Site Key in Your App

Open `lib/core/config/turnstile_config.dart` and replace the placeholder:

```dart
class TurnstileConfig {
  static const String siteKey = 'YOUR_ACTUAL_SITE_KEY_HERE';
}
```

### 3. Test Keys (for Development)

Cloudflare provides test keys that you can use during development:

```dart
// Always passes verification
static const String siteKey = '1x00000000000000000000AA';

// Always blocks verification (for testing error handling)
static const String siteKey = '2x00000000000000000000AB';

// Forces interactive challenge
static const String siteKey = '3x00000000000000000000FF';
```

## How It Works

### Login Flow

1. User enters credentials
2. App calls `TurnstileService.generateToken(context)`
3. WebView opens with Turnstile challenge
4. User completes challenge (usually invisible)
5. Token is returned to the app
6. App sends login request with token
7. Backend validates token with Cloudflare

```dart
// In login screen
final turnstileToken = await TurnstileService.generateToken(context);
if (turnstileToken != null) {
  context.read<AuthCubit>().loginWithTurnstile(
    email,
    password,
    turnstileToken
  );
}
```

### Registration Flow

Same process as login:

```dart
// In signup screen
final turnstileToken = await TurnstileService.generateToken(context);
if (turnstileToken != null) {
  userData['turnstileToken'] = turnstileToken;
  context.read<AuthCubit>().register(userData);
}
```

## Implementation Details

### Files Modified/Created

1. **Created:**
   - `lib/core/services/turnstile_service.dart` - Token generation service
   - `lib/core/config/turnstile_config.dart` - Configuration
   - `docs/turnstile_integration.md` - This guide

2. **Modified:**
   - `lib/features/auth/presentation/screens/login/login.dart` - Added token generation
   - `lib/features/auth/presentation/screens/signup/signup.dart` - Added token generation
   - `lib/features/auth/presentation/cubit/auth_cubit.dart` - Added convenience method

### API Request Format

The token is sent in the request body:

**Login:**
```json
{
  "identifier": "ah@gmail.com",
  "password": "Ahmed#123#",
  "turnstileToken": "0.abc123..."
}
```

**Registration:**
```json
{
  "email": "ah@gmail.com",
  "password": "Ahmed#123#",
  "firstName": "cavani",
  "lastName": "org",
  "mobile": "+201030756862",
  "turnstileToken": "0.abc123..."
}
```

## Backend Validation

Your backend must validate the token with Cloudflare:

```javascript
// Example Node.js validation
async function validateTurnstile(token, remoteip) {
  const response = await fetch(
    'https://challenges.cloudflare.com/turnstile/v0/siteverify',
    {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        secret: 'YOUR_SECRET_KEY',
        response: token,
        remoteip: remoteip  // Optional but recommended
      })
    }
  );
  
  const data = await response.json();
  return data.success;
}
```

## User Experience

### Normal Flow (Invisible)
- User clicks login/register
- Brief loading indicator
- Challenge completes automatically
- User proceeds without interruption

### Suspicious Activity Detected
- User clicks login/register
- Turnstile shows interactive challenge
- User completes challenge (checkbox or puzzle)
- User proceeds after verification

### Failed Verification
- Error message shown
- User can try again
- App provides feedback

## Error Handling

### If Token Generation Fails

**Login:**
```dart
if (turnstileToken == null) {
  setState(() {
    _errorMessage = 'Security verification failed. Please try again.';
  });
  return;
}
```

**Registration:**
```dart
if (turnstileToken == null) {
  Get.snackbar(
    'Security Verification Failed',
    'Unable to complete security verification. Please try again.',
  );
  return;
}
```

## Testing

### Test Token Generation
```dart
final token = await TurnstileService.generateToken(context);
print('Token: $token'); // Should print a valid token string
```

### Test API Integration
1. Use test site key (always passes)
2. Complete login/registration
3. Check backend receives token
4. Verify backend validation works

## Security Considerations

1. **Never expose your secret key** - Keep it on the backend only
2. **Validate on backend** - Never trust client-side validation
3. **Token is single-use** - Each request needs a new token
4. **Token expires** - Tokens are valid for ~5 minutes
5. **Use HTTPS** - Always transmit tokens over secure connections

## Customization

### Change Turnstile Theme

Edit `viewer.html` in `turnstile_service.dart`:

```html
<div class="cf-turnstile" 
     data-sitekey="${widget.siteKey}"
     data-callback="onTurnstileSuccess"
     data-theme="dark">  <!-- Change to 'dark' -->
</div>
```

### Change Appearance

Options for `data-appearance`:
- `always` - Always show the widget
- `execute` - Execute automatically
- `interaction-only` - Only show if needed

### Change Size

Options for `data-size`:
- `normal` - Standard size (default)
- `compact` - Smaller size
- `flexible` - Responsive size

## Troubleshooting

### Token is null
- Check internet connection
- Verify site key is correct
- Check Cloudflare dashboard for domain restrictions

### Backend rejects token
- Verify secret key on backend
- Check token hasn't expired
- Ensure token is being sent correctly
- Verify backend validation logic

### Challenge always appears
- This is normal for suspicious IPs/devices
- Test with different network/device
- Check Cloudflare security settings

### WebView doesn't load
- Check internet permissions (Android)
- Verify WebView is enabled
- Check console for JavaScript errors

## Additional Resources

- [Cloudflare Turnstile Docs](https://developers.cloudflare.com/turnstile/)
- [Turnstile Dashboard](https://dash.cloudflare.com/turnstile)
- [API Documentation](https://developers.cloudflare.com/turnstile/get-started/server-side-validation/)

## Support

For issues specific to:
- **Turnstile:** Check Cloudflare documentation
- **Flutter Implementation:** Check this codebase
- **Backend Validation:** Consult backend team

---

**Note:** Make sure to update `TurnstileConfig.siteKey` with your actual site key before deploying to production!
