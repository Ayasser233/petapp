import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';

class EnterVerificationCodeScreen extends StatefulWidget {
  const EnterVerificationCodeScreen({super.key});

  @override
  State<EnterVerificationCodeScreen> createState() => _EnterVerificationCodeScreenState();
}

class _EnterVerificationCodeScreenState extends State<EnterVerificationCodeScreen> {
  // Controllers for OTP fields
  final List<TextEditingController> _controllers = List.generate(
    4, 
    (_) => TextEditingController()
  );
  
  // Focus nodes for each field
  final List<FocusNode> _focusNodes = List.generate(
    4, 
    (_) => FocusNode()
  );
  
  bool _isLoading = false;
  int _resendTimer = 60; // 60 seconds countdown
  Timer? _timer;
  String? _errorMessage;
  final String _email;
  
  // Get email from arguments
  _EnterVerificationCodeScreenState() : _email = Get.arguments ?? 'your email';
  
  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }
  
  @override
  void dispose() {
    // Clean up controllers and focus nodes
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }
  
  // Start countdown timer for resend code
  void _startResendTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }
  
  // Handle resend code
  Future<void> _handleResendCode() async {
    if (_resendTimer > 0) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // Generate a new random code
      final newCode = _generateRandomCode();
      
      // For debugging
      print('Generated new verification code: $newCode for $_email');
      
      // Store the new code
      await _storeVerificationCode(_email, newCode);
      
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Reset fields
      for (final controller in _controllers) {
        controller.clear();
      }
      
      // Reset timer
      _resendTimer = 60;
      _startResendTimer();
      
      // Show success message
      Get.snackbar(
        'Code Sent',
        'A new verification code has been sent to $_email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to resend code. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  // Handle verification
  Future<void> _handleVerification() async {
    // Get the complete code
    final enteredCode = _controllers.map((c) => c.text).join();
    
    // Validate the code length
    if (enteredCode.length != 4) {
      setState(() {
        _errorMessage = 'Please enter all 4 digits of the code';
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get stored verification code
      final storedCode = prefs.getString('verification_code_$_email');
      
      // Get timestamp when code was created
      final timestamp = prefs.getInt('verification_code_timestamp_$_email') ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;
      
      // Check if code is expired (10 minutes = 600000 milliseconds)
      final isExpired = (now - timestamp) > 600000;
      
      if (isExpired) {
        setState(() {
          _errorMessage = 'Verification code has expired. Please request a new one.';
        });
        return;
      }
      
      // For debugging
      print('Entered code: $enteredCode, Stored code: $storedCode');
      
      // Compare entered code with stored code
      if (enteredCode == storedCode) {
        // Code is valid
        
        // Simulate API call delay
        await Future.delayed(const Duration(seconds: 1));
        
        // Navigate to create new password screen
        Get.toNamed(AppRoutes.createNewPassword, arguments: _email);
      } else {
        // Invalid code
        setState(() {
          _errorMessage = 'Invalid verification code. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error verifying code: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Enter Verification Code',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              'We have sent a verification code to $_email',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32.0),
            
            // OTP Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                4,
                (index) => SizedBox(
                  width: 60,
                  height: 60,
                  child: TextFormField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      // Clear error when typing
                      if (_errorMessage != null) {
                        setState(() {
                          _errorMessage = null;
                        });
                      }
                      
                      if (value.isNotEmpty) {
                        // Auto-advance to next field
                        if (index < 3) {
                          _focusNodes[index + 1].requestFocus();
                        } else {
                          // Last field - hide keyboard
                          _focusNodes[index].unfocus();
                        }
                      }
                    },
                    decoration: InputDecoration(
                      counterText: '',
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
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(color: AppColors.orange, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                      errorStyle: const TextStyle(height: 0),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16.0),
            
            // Error message
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            
            // Resend timer text
            Text(
              _resendTimer > 0 
                ? 'You can resend the code in $_resendTimer seconds'
                : 'Didn\'t receive the code?',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
            
            const SizedBox(height: 8.0),
            
            // Resend button
            TextButton(
              onPressed: _resendTimer > 0 ? null : _handleResendCode,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.orange,
                disabledForegroundColor: Colors.grey,
              ),
              child: Text(
                'Resend Code',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _resendTimer > 0 ? Colors.grey : AppColors.orange,
                ),
              ),
            ),
            
            const SizedBox(height: 32.0),
            
            // Verify button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleVerification,
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
                      'Verify',
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
    );
  }
}