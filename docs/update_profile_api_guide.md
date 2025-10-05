# Update Profile API Implementation Guide

## Overview
The update profile API is now fully implemented and ready to use! This guide shows you how to update user profile information using the `/api/v1/auth/me` endpoint.

## API Endpoint
- **URL:** `PATCH /api/v1/auth/me`  
- **Authentication:** Required (Bearer token)
- **Content-Type:** `application/json`

## Available Fields for Update
```json
{
  "firstName": "string (optional)",
  "lastName": "string (optional)", 
  "email": "string (optional)",
  "phone": "string (optional)",
  "mobile": "string (optional)",
  "username": "string (optional)",
  "address": "string (optional)",
  "dateOfBirth": "string (optional, YYYY-MM-DD format)"
}
```

## How to Use

### 1. Simple Profile Updates (In Your Controllers/Services)

```dart
// Get the profile controller
final profileController = Get.find<ProfileController>();

// Update name
await profileController.updateProfile(
  firstName: 'John',
  lastName: 'Doe',
);

// Update email
await profileController.updateProfile(
  email: 'john.doe@example.com',
);

// Update multiple fields
await profileController.updateProfile(
  firstName: 'John',
  lastName: 'Doe',
  email: 'john.doe@example.com',
  phone: '+1234567890',
  address: '123 Main St, City, Country',
);

// Update with backward compatibility (using full name)
await profileController.updateProfileWithName(
  name: 'John Doe',
  email: 'john.doe@example.com',
  phone: '+1234567890',
);
```

### 2. With Loading States and Error Handling

```dart
class MyProfilePage extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    
    return Obx(() {
      if (profileController.isUpdating) {
        return Center(child: CircularProgressIndicator());
      }
      
      return YourProfileForm(
        onUpdate: (profileData) async {
          final success = await profileController.updateProfile(
            firstName: profileData['firstName'],
            lastName: profileData['lastName'],
            email: profileData['email'],
            // ... other fields
          );
          
          if (success) {
            // Handle success - maybe navigate back or show success message
            Get.back();
          }
          // Error handling is automatic via ErrorHandlerService
        },
      );
    });
  }
}
```

### 3. With Field-Specific Error Handling

```dart
// In your form widget
validator: FieldErrorHelper.createValidator(
  fieldErrors, // From your state
  'email',     // Field name that matches server response
  existingValidator: ValidationUtils.validateEmail, // Your existing validation
),
```

## Response Format

### Success Response (200)
```json
{
  "id": "user-id",
  "firstName": "John",
  "lastName": "Doe", 
  "name": "John Doe",
  "email": "john.doe@example.com",
  "phone": "+1234567890",
  "emailVerified": true,
  "createdAt": "2025-10-03T10:00:00Z",
  "updatedAt": "2025-10-04T12:30:00Z"
}
```

### Error Response (400) - Validation Errors
```json
{
  "statusCode": 400,
  "message": "Bad Request Exception",
  "errorDetails": {
    "message": [
      {"email": "Email is already taken"},
      {"phone": "Invalid phone number format"}
    ]
  }
}
```

## Testing Your Implementation

### 1. Test Basic Update
```dart
void testUpdateProfile() async {
  final profileController = Get.find<ProfileController>();
  
  print('📝 Testing profile update...');
  
  final success = await profileController.updateProfile(
    firstName: 'Test',
    lastName: 'User',
  );
  
  if (success) {
    print('✅ Profile updated successfully!');
    print('Updated profile: ${profileController.userProfile?.name}');
  } else {
    print('❌ Profile update failed');
  }
}
```

### 2. Test Error Handling
```dart
void testValidationErrors() async {
  final profileController = Get.find<ProfileController>();
  
  // Try updating with invalid email
  final success = await profileController.updateProfile(
    email: 'invalid-email',
  );
  
  // Should return false and show validation error
  print('Result: $success'); // Should be false
}
```

## Integration with Existing Forms

### Option 1: Update Your Existing Profile Form
```dart
// In your existing profile form submission
void _submitForm() async {
  if (_formKey.currentState?.validate() ?? false) {
    final profileController = Get.find<ProfileController>();
    
    final success = await profileController.updateProfile(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );
    
    if (success) {
      Get.back(); // or navigate to profile page
    }
  }
}
```

### Option 2: Use the Complete Example
The complete example form is available in:
`/features/profile/presentation/screens/examples/update_profile_example.dart`

## Key Features

✅ **Field-Specific Validation**: Server validation errors are mapped to specific form fields  
✅ **Loading States**: Automatic loading indicators while updating  
✅ **Error Handling**: Automatic error display with user-friendly messages  
✅ **Optimistic Updates**: Local profile data is updated on success  
✅ **Backward Compatibility**: Works with existing `name` field approach  
✅ **Type Safety**: Strongly typed request/response models  
✅ **Debug Logging**: Comprehensive logging for troubleshooting  

## Common Use Cases

1. **Profile Settings Page**: Full profile editing form
2. **Quick Name Update**: Simple name change dialog  
3. **Email Verification**: Update email and trigger verification
4. **Phone Update**: Update contact information
5. **Address Management**: Update user address

## Authentication
- The API automatically includes the `Authorization: Bearer <token>` header
- Token is managed by `TokenService` and added via interceptors
- If token is expired, the user will be redirected to login

## Error Handling
- **Network Errors**: Handled by `ErrorHandlerService` with user-friendly messages
- **Validation Errors**: Field-specific errors displayed under form fields  
- **Server Errors**: Generic server errors shown as snackbars
- **Token Errors**: Automatic logout and redirect to login

Your update profile functionality is now complete and production-ready! 🚀