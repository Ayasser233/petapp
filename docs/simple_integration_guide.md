# Simple Integration Guide for Your Existing Auth Screens

## Integration with Your Current Login Screen

Here's how to integrate field error handling with your existing `LoginForm` class:

### Step 1: Add Field Error State

Add this to your `_LoginFormState` class after the existing state variables:

```dart
class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  String? _errorMessage;
  
  // ADD THIS LINE:
  Map<String, String>? _fieldErrors;
  
  // ... rest of your existing code
}
```

### Step 2: Update Your BlocListener

Replace your existing BlocListener error handling:

```dart
// REPLACE THIS:
} else if (state is AuthFailure) {
  setState(() {
    _errorMessage = AppLocalizations.of(context).wrongCredentials;
  });
}

// WITH THIS:
} else if (state is AuthFailure) {
  setState(() {
    if (state.fieldErrors != null && state.fieldErrors!.isNotEmpty) {
      // Handle field-specific errors
      _fieldErrors = state.fieldErrors;
      _errorMessage = null; // Clear general error
    } else {
      // Handle general errors
      _errorMessage = AppLocalizations.of(context).wrongCredentials;
      _fieldErrors = null; // Clear field errors
    }
  });
}
```

### Step 3: Add Field Error Helper Import

Add this import at the top of your login.dart file:

```dart
import 'package:petapp/core/utils/field_error_helper.dart';
```

### Step 4: Update Your Email Field Validator

Replace your existing email validator:

```dart
// REPLACE THIS:
validator: ValidationUtils.validateEmail,

// WITH THIS:
validator: FieldErrorHelper.createValidator(
  _fieldErrors,
  'email',
  existingValidator: ValidationUtils.validateEmail,
),
```

### Step 5: Update Your Password Field Validator

Replace your existing password validator:

```dart
// REPLACE THIS:
validator: ValidationUtils.validatePassword,

// WITH THIS:
validator: FieldErrorHelper.createValidator(
  _fieldErrors,
  'password',
  existingValidator: ValidationUtils.validatePassword,
),
```

### Step 6: Add Field Error Display (Optional)

Add this **after** your form fields and **before** the remember me row:

```dart
// Add field errors display
FieldErrorHelper.buildFieldErrorsList(_fieldErrors),

if (_fieldErrors != null && _fieldErrors!.isNotEmpty) 
  const SizedBox(height: 16),

// Error message below password (your existing code)
if (_errorMessage != null)
  Padding(
    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        _errorMessage!,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  ),
```

### Step 7: Clear Field Errors on Input (Optional)

Add this to your email field's `onChanged`:

```dart
onChanged: (value) {
  // Clear field error when user starts typing
  if (_fieldErrors != null && _fieldErrors!.containsKey('email')) {
    setState(() {
      _fieldErrors!.remove('email');
    });
  }
  setState(() {}); // Your existing setState
},
```

And similar for password field:

```dart
onChanged: (value) {
  // Clear field error when user starts typing
  if (_fieldErrors != null && _fieldErrors!.containsKey('password')) {
    setState(() {
      _fieldErrors!.remove('password');
    });
  }
},
```

## Similar Changes for SignUp Screen

Apply the same pattern to your signup screen:

1. Add `Map<String, String>? _fieldErrors;` to state
2. Update BlocListener to handle field errors
3. Update validators for firstName, email, password fields
4. Add field error display

## What This Gives You

✅ **Server field errors** will now display under each specific field  
✅ **Your existing ValidationUtils** continue to work exactly as before  
✅ **Minimal changes** to your existing code  
✅ **Better user experience** with clear field-specific feedback  

## Example Server Response Handling

When your server returns:
```json
{
  "statusCode": 400,
  "message": "Bad Request Exception",
  "errorDetails": {
    "message": [
      {"email": "Please provide a valid email address"},
      {"password": "Password must be at least 8 characters long..."}
    ]
  }
}
```

Your app will now:
1. Show "Please provide a valid email address" under the email field
2. Show "Password must be at least 8 characters long..." under the password field  
3. Clear field errors when the user starts typing in each field
4. Validate locally first, then show server errors if local validation passes

Your existing ValidationUtils validation logic remains untouched and works perfectly with the new field error system!