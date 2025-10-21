# Phone Number Validation Implementation

## Summary
Implemented comprehensive phone number validation for the registration form with the following requirements:
1. Phone numbers cannot start with 0
2. Client-side validation errors only appear after user interaction
3. Real-time validation with user-friendly error messages

## Changes Made

### 1. Updated Validation Regex (`lib/core/utils/validation_utils.dart`)

**Old Regex:**
```dart
static final RegExp _phoneRegex = RegExp(
  r'^\+?[0-9]{1,3}[0-9]{6,14}$',
);
```

**New Regex:**
```dart
// Phone number without country code - should not start with 0
// Must be 6-14 digits, starting with 1-9
static final RegExp _phoneWithoutCountryCodeRegex = RegExp(
  r'^[1-9][0-9]{5,13}$',
);
```

### 2. Enhanced `validatePhone()` Method

**New Features:**
- ✅ Checks if phone starts with 0 and returns specific error
- ✅ Only validates when `shouldValidate` flag is true (after user interaction)
- ✅ Clear error messages for different scenarios

```dart
static String? validatePhone(String? value, {String? countryCode, bool shouldValidate = true}) {
  // Don't show error if field is empty and we're not forcing validation
  if (!shouldValidate && (value == null || value.isEmpty)) {
    return null;
  }
  
  if (value == null || value.isEmpty) {
    return 'Please enter your phone number';
  }
  
  // Check if phone starts with 0
  if (value.startsWith('0')) {
    return 'Phone number cannot start with 0';
  }
  
  // Validate the phone number format without country code
  if (!_phoneWithoutCountryCodeRegex.hasMatch(value)) {
    return 'Please enter a valid phone number (6-14 digits)';
  }
  
  return null;
}
```

### 3. Updated PhoneInputField Widget (`lib/core/widgets/phone_input_field.dart`)

**Added Features:**
- ✅ Interaction tracking with `_hasInteracted` flag
- ✅ Form field key for programmatic validation
- ✅ Validation only triggers after user starts typing

**Key Changes:**
```dart
class _PhoneInputFieldState extends State<PhoneInputField> {
  CountryCode _selectedCountry = CountryCodes.commonCodes.first;
  bool _hasInteracted = false;
  final _formFieldKey = GlobalKey<FormFieldState>();

  // Validation only runs if user has interacted
  validator: (value) {
    return ValidationUtils.validatePhone(
      value, 
      countryCode: _selectedCountry.dialCode,
      shouldValidate: _hasInteracted,
    );
  },
  
  // Mark as interacted when user types
  onChanged: (value) {
    if (!_hasInteracted && value.isNotEmpty) {
      setState(() {
        _hasInteracted = true;
      });
    }
    
    // Trigger validation after interaction
    if (_hasInteracted) {
      _formFieldKey.currentState?.validate();
    }
    // ...
  },
}
```

### 4. Updated SignUp Form (`lib/features/auth/presentation/screens/signup/signup.dart`)

**Added Interaction Tracking:**
```dart
// Track if fields have been interacted with
bool _firstNameTouched = false;
bool _lastNameTouched = false;
bool _phoneTouched = false;
bool _emailTouched = false;
bool _passwordTouched = false;
```

**Updated All Form Fields:**
- Changed `autovalidateMode` from `AutovalidateMode.onUserInteraction` to `AutovalidateMode.disabled`
- Added custom validators that check if field has been touched
- Added touch tracking in `onChanged` callbacks

**Example (First Name Field):**
```dart
TextFormField(
  controller: _firstNameController,
  autovalidateMode: AutovalidateMode.disabled,
  validator: (value) {
    if (!_firstNameTouched) return null;
    return ValidationUtils.validateName(value);
  },
  onChanged: (value) {
    if (!_firstNameTouched) {
      setState(() => _firstNameTouched = true);
    }
    setState(() {
      _firstNameError = null;
    });
  },
)
```

**Updated Form Validation:**
```dart
void _checkFormValidity() {
  final isValid = _firstNameController.text.isNotEmpty &&
      _lastNameController.text.isNotEmpty &&
      _phoneController.text.isNotEmpty &&
      !_phoneController.text.startsWith('0') && // ← NEW: Check phone doesn't start with 0
      _emailController.text.isNotEmpty &&
      _emailController.text.contains('@') &&
      _passwordController.text.isNotEmpty &&
      _passwordController.text.length >= 6;

  setState(() {
    _isFormValid = isValid;
  });
}
```

**Updated Submit Handler:**
```dart
void _handleSignUp() {
  // Mark all fields as touched to show validation errors
  setState(() {
    _firstNameTouched = true;
    _lastNameTouched = true;
    _phoneTouched = true;
    _emailTouched = true;
    _passwordTouched = true;
  });
  
  // Validate form
  if (_formKey.currentState?.validate() != true) {
    return;
  }
  // ... proceed with registration
}
```

## Validation Rules

### Phone Number Rules:
1. ✅ **Cannot start with 0** - Shows error: "Phone number cannot start with 0"
2. ✅ **Must be 6-14 digits** - Shows error: "Please enter a valid phone number (6-14 digits)"
3. ✅ **Digits only** - Enforced by `FilteringTextInputFormatter.digitsOnly`
4. ✅ **Required field** - Shows error: "Please enter your phone number"

### Validation Behavior:
- **Before interaction**: No validation errors shown
- **After first keystroke**: Validation begins
- **Real-time validation**: Updates as user types
- **On submit**: All fields marked as touched, showing all errors

## User Experience Flow

### 1. Initial State
```
User opens registration form
  ↓
All fields are empty
  ↓
No validation errors shown ✓
```

### 2. User Interaction
```
User types in phone field
  ↓
Field marked as "touched"
  ↓
Validation runs on every keystroke
  ↓
Shows errors if invalid ✓
```

### 3. Phone Starting with 0
```
User types "0123456789"
  ↓
Validation detects "0" at start
  ↓
Shows: "Phone number cannot start with 0" ✓
  ↓
Submit button disabled ✓
```

### 4. Valid Phone Number
```
User types "1234567890"
  ↓
Passes all validations
  ↓
No error shown ✓
  ↓
Submit button enabled ✓
```

### 5. Submit Without Interaction
```
User clicks submit without typing
  ↓
All fields marked as touched
  ↓
All validation errors appear
  ↓
Form doesn't submit ✓
```

## Testing Scenarios

### Test 1: Phone Cannot Start with 0
**Steps:**
1. Open registration form
2. Click on phone field
3. Type "0"
4. Continue typing "1234567890"

**Expected:**
- ❌ Error appears: "Phone number cannot start with 0"
- ❌ Submit button disabled
- ✅ Error clears when user deletes "0"

### Test 2: Valid Phone Numbers
**Test Cases:**
- ✅ "1234567890" (10 digits)
- ✅ "123456" (minimum 6 digits)
- ✅ "12345678901234" (maximum 14 digits)
- ✅ "5551234567"

### Test 3: Invalid Phone Numbers
**Test Cases:**
- ❌ "0123456789" (starts with 0)
- ❌ "12345" (too short - 5 digits)
- ❌ "123456789012345" (too long - 15 digits)

### Test 4: No Premature Errors
**Steps:**
1. Open registration form
2. Don't touch any fields
3. Observe the form

**Expected:**
- ✅ No error messages visible
- ✅ All fields have placeholder text
- ✅ Submit button disabled (no data entered)

### Test 5: Error After Interaction
**Steps:**
1. Click on phone field
2. Type "0"
3. Move to another field

**Expected:**
- ❌ Error appears immediately after typing "0"
- ❌ Error persists when moving to another field
- ✅ Error clears when deleting "0"

## Error Messages

| Scenario | Error Message |
|----------|---------------|
| Empty field (on submit) | "Please enter your phone number" |
| Starts with 0 | "Phone number cannot start with 0" |
| Too short/long or invalid | "Please enter a valid phone number (6-14 digits)" |

## Benefits

1. **User-Friendly**: No error spam on page load
2. **Real-Time Feedback**: Immediate validation after interaction
3. **Clear Messages**: Specific error for "starts with 0"
4. **Consistent**: All fields follow same interaction pattern
5. **Backend Ready**: Phone format validated before API call

## Files Modified

| File | Changes |
|------|---------|
| `lib/core/utils/validation_utils.dart` | Updated phone regex, added "no 0 start" check |
| `lib/core/widgets/phone_input_field.dart` | Added interaction tracking, conditional validation |
| `lib/features/auth/presentation/screens/signup/signup.dart` | Added touch tracking for all fields, updated validators |

## API Integration

The validated phone number is sent to the backend in the format:
```dart
'mobile': '${_selectedCountry.dialCode}${_phoneController.text}'
// Example: "+201234567890" (assuming Egypt +20 and number 1234567890)
```

**Note:** The country code is added automatically, so the user only needs to enter the phone number without the leading 0.

## Future Enhancements

1. **Country-Specific Validation**: Different rules per country
2. **Format Display**: Show number with separators (123-456-7890)
3. **International Format**: Support + prefix for direct input
4. **Phone Verification**: OTP verification for phone numbers
