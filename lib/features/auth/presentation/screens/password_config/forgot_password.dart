import 'dart:math'; // Add this for generating random codes
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:iconsax/iconsax.dart';
import 'package:petapp/core/styles/input_styles.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this for storage

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  
  // Validate email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Please enter a valid email';
    }
    return null;
  }
  
  // Handle send OTP
  Future<void> _handleSendOTP() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Get email
    final email = _emailController.text.trim();

    setState(() {
      _isLoading = true;
    });
    
    try {
      // Generate a random 4-digit verification code
      final verificationCode = _generateRandomCode();
      
      // For debugging - print code to console
      print('Generated verification code: $verificationCode for $email');
      
      // Store the code locally - in a real app this would be on the server
      await _storeVerificationCode(email, verificationCode);
      
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Navigate to verification screen
      Get.toNamed(
        AppRoutes.enterVerificationCode, 
        arguments: email
      );
      
      // Show success message
      Get.snackbar(
        'Code Sent',
        'Verification code has been sent to $email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send verification code: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  // Generate a random 4-digit code
  String _generateRandomCode() {
    final random = Random();
    return (1000 + random.nextInt(9000)).toString(); // Ensures 4 digits
  }
  
  // Store verification code locally (simulated server storage)
  Future<void> _storeVerificationCode(String email, String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('verification_code_$email', code);
    
    // Store timestamp for expiration
    await prefs.setInt(
      'verification_code_timestamp_$email',
      DateTime.now().millisecondsSinceEpoch
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reset Your Password',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Enter your registered email to receive a verification code',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32.0),
              
              // Email Field (removed separate label)
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.sms, color: AppColors.orange),
                  hintText: 'Email',
                  hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[400],
                  ),
                  filled: true,
                  fillColor: isDark ? AppColors.lightblack : Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedErrorBorder: focusedFieldStyle(),
                  focusedBorder: focusedFieldStyle(),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  errorStyle: const TextStyle(height: 0.8),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _validateEmail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              
              const SizedBox(height: 32.0),
              
              // Send OTP Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSendOTP,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: AppColors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: AppColors.orange.withOpacity(0.5),
                  ),
                  child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.0,
                        ),
                      )
                    : Text(
                        'Send Verification Code',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}