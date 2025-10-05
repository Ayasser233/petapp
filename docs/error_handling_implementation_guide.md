# Server Error Response Handling Implementation Guide

## Overview
This guide explains how to handle the new server error response format in your Flutter app's auth system.

## Server Response Format
Your server now returns validation errors in this format:
```json
{
  "statusCode": 400,
  "message": "Bad Request Exception",
  "errorDetails": {
    "message": [
      {"email": "Please provide a valid email address"},
      {"password": "Password must be at least 8 characters long and contain at least 1 lowercase letter and 1 number"}
    ],
    "error": "Bad Request",
    "statusCode": 400
  }
}
```

## What Was Updated

### 1. Error Handler Service (`core/services/error_handler_service.dart`)
- **Enhanced** to parse the new `errorDetails.message` array format
- **Extracts** individual field errors from the nested structure
- **Maintains** backward compatibility with existing error formats
- **Shows** the first field error in snackbars for user feedback

### 2. Auth Cubit (`features/auth/presentation/cubit/auth_cubit.dart`)
- **Updated** `_extractFieldErrors()` method to handle new format
- **Extracts** field-specific errors from `errorDetails.message` array
- **Returns** `Map<String, String>` with field names and error messages
- **Maintains** support for legacy error formats

### 3. Field Error Helper (`core/utils/field_error_helper.dart`)
- **New utility class** for handling field errors in UI
- **Provides** methods to extract, validate, and display field errors
- **Includes** form integration helpers and UI components

### 4. Auth State (`features/auth/presentation/cubit/auth_state.dart`)
- **Already supports** `fieldErrors` in `AuthFailure` state
- **No changes needed** - existing structure works perfectly

## How to Use Field Errors in Your UI

### Option 1: Display All Field Errors at Top
```dart
// In your BlocConsumer/BlocBuilder
if (state is AuthFailure && state.fieldErrors != null) {
  return FieldErrorHelper.buildFieldErrorsList(state.fieldErrors);
}
```

### Option 2: Field-Specific Error Handling
```dart
TextFormField(
  controller: emailController,
  decoration: InputDecoration(
    labelText: 'Email',
    // Highlight field with error styling
    errorBorder: FieldErrorHelper.hasFieldError(fieldErrors, 'email')
        ? OutlineInputBorder(borderSide: BorderSide(color: Colors.red))
        : null,
  ),
  // Use helper to create validator
  validator: FieldErrorHelper.createValidator(fieldErrors, 'email'),
  onChanged: (value) {
    // Clear field error when user types
    if (fieldErrors?.containsKey('email') == true) {
      setState(() {
        fieldErrors!.remove('email');
      });
    }
  },
)
```

### Option 3: Show Field Errors in Dialog
```dart
if (state is AuthFailure && state.fieldErrors != null) {
  FieldErrorHelper.showFieldErrorsDialog(
    context, 
    state.fieldErrors,
    title: 'Please fix the following errors:',
  );
}
```

## Integration Steps

### 1. Update Your Existing Forms
Replace your current error handling in auth screens:

**Before:**
```dart
BlocListener<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state is AuthFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  // ...
)
```

**After:**
```dart
BlocListener<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state is AuthFailure) {
      if (state.fieldErrors != null && state.fieldErrors!.isNotEmpty) {
        // Handle field-specific errors
        setState(() {
          fieldErrors = state.fieldErrors;
        });
      } else {
        // Handle general errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      }
    }
  },
  // ...
)
```

### 2. Add Field Error Display
Add this to your form widget:
```dart
// Display field errors
FieldErrorHelper.buildFieldErrorsList(fieldErrors),
if (fieldErrors != null && fieldErrors!.isNotEmpty) 
  const SizedBox(height: 16),
```

### 3. Update Form Fields (Optional)
For enhanced UX, update your TextFormFields to use field-specific validation:
```dart
validator: FieldErrorHelper.createValidator(
  fieldErrors,
  'email', // field name from server
  additionalValidator: (value) {
    // Your existing validation logic
    if (value?.isEmpty == true) return 'Email is required';
    return null;
  },
),
```

## Error Response Mapping

| Server Field | Description | UI Display |
|-------------|-------------|------------|
| `email` | Email validation errors | Email TextFormField |
| `password` | Password validation errors | Password TextFormField |
| `firstName` | First name validation | First name field |
| `lastName` | Last name validation | Last name field |
| `username` | Username validation | Username field |
| `mobile` | Phone validation | Phone field |

## Testing Your Implementation

1. **Test with invalid email**: Should show email-specific error
2. **Test with weak password**: Should show password-specific error  
3. **Test with multiple errors**: Should display all field errors
4. **Test field clearing**: Errors should clear when user starts typing
5. **Test network errors**: Should fall back to general error display

## Benefits

✅ **Better UX**: Users see exactly which fields need fixing  
✅ **Clear Feedback**: Field-specific error messages  
✅ **Real-time Updates**: Errors clear as user fixes them  
✅ **Flexible Display**: Multiple ways to show errors  
✅ **Backward Compatible**: Works with existing error formats  
✅ **Type Safe**: Structured error handling with proper types

## Example Files Created

- `core/utils/field_error_helper.dart` - Utility functions
- `features/auth/presentation/screens/examples/field_error_handling_example.dart` - Complete examples

## Next Steps

1. **Update your login screen** with field error handling
2. **Update your registration screen** with field error handling  
3. **Test with your actual API** to ensure proper error mapping
4. **Customize the UI styling** to match your app's design
5. **Add field error handling to other forms** (profile update, etc.)

Your error handling system is now ready to provide users with clear, actionable feedback on form validation errors!