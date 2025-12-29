import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/services/api_client.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/arabic_numeral_formatter.dart';
import 'package:petapp/core/utils/formatters.dart';
import 'package:petapp/core/utils/helper_functions.dart';

class EnterVerificationCodeScreen extends StatefulWidget {
  const EnterVerificationCodeScreen({super.key});

  @override
  State<EnterVerificationCodeScreen> createState() =>
      _EnterVerificationCodeScreenState();
}

class _EnterVerificationCodeScreenState
    extends State<EnterVerificationCodeScreen> {
  // Controllers for OTP fields (changed to 6 digits)
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());

  // Focus nodes for each field
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  late final ApiClient _apiClient;
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
    _apiClient = Get.find<ApiClient>();
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
      final localizations = AppLocalizations.of(context);

      // Call the resend reset OTP API (for password reset flow)
      final response = await _apiClient.resendResetOtp(_email);

      // Check if the response is successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Reset fields
        for (final controller in _controllers) {
          controller.clear();
        }

        // Reset timer
        _resendTimer = 60;
        _startResendTimer();

        // Show success message
        Get.snackbar(
          localizations.newCodeSent,
          localizations.newVerificationCodeSentTo(_email),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
          duration: const Duration(seconds: 3),
        );
      }
    } on DioException catch (e) {
      final localizations = AppLocalizations.of(context);
      String errorMessage = localizations.failedToResendCode;

      // Handle specific error codes
      if (e.response != null &&
          e.response?.data != null &&
          e.response?.data['message'] != null) {
        errorMessage = e.response?.data['message'];
      }

      setState(() {
        _errorMessage = errorMessage;
      });
    } catch (e) {
      final localizations = AppLocalizations.of(context);
      setState(() {
        _errorMessage = localizations.failedToResendCode;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Handle verification
  Future<void> _handleVerification() async {
    final localizations = AppLocalizations.of(context);

    // Get the complete code and convert Arabic numerals to English
    final enteredCode =
        _controllers.map((c) => TFormatter.toEnglishNumerals(c.text)).join();

    // Validate the code length
    if (enteredCode.length != 6) {
      setState(() {
        _errorMessage = localizations.pleaseEnterAll6Digits;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Call the verify reset OTP API (for password reset flow)
      final response = await _apiClient.verifyResetOtp(_email, enteredCode);

      // Check if the response is successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Extract the resetToken from the response
        final resetToken = response.data['resetToken'] as String?;

        if (resetToken == null || resetToken.isEmpty) {
          setState(() {
            _errorMessage = localizations.errorVerifyingCode;
          });
          return;
        }

        // Code is valid - Navigate to create new password screen with email and resetToken
        Get.toNamed(AppRoutes.createNewPassword, arguments: {
          'email': _email,
          'resetToken': resetToken,
        });
      }
    } on DioException catch (e) {
      // Handle API errors
      String errorMessage = localizations.invalidVerificationCode;

      if (e.response != null) {
        // Check for specific error codes
        if (e.response?.statusCode == 400) {
          errorMessage = localizations.invalidVerificationCode;
        } else if (e.response?.statusCode == 410) {
          // Code expired
          errorMessage = localizations.verificationCodeExpired;
        } else if (e.response?.data != null &&
            e.response?.data['message'] != null) {
          // Use the error message from the API
          errorMessage = e.response?.data['message'];
        }
      }

      setState(() {
        _errorMessage = errorMessage;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '${localizations.errorVerifyingCode}: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                localizations.enterVerificationCode,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              Text(
                localizations.verificationCodeSentToEmail(_email),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32.0),

              // OTP Fields (6 digits)
              Builder(
                builder: (context) {
                  final locale = Localizations.localeOf(context);
                  final isArabic = locale.languageCode == 'ar';

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      6,
                      (index) => SizedBox(
                        width: 48,
                        height: 60,
                        child: TextFormField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          inputFormatters: [
                            ArabicAwareDigitsOnlyFormatter(),
                            // Allow both English and Arabic digits
                            ArabicNumeralInputFormatter(isArabic),
                            // Convert to Arabic for display
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
                              if (index < 5) {
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
                            fillColor: isDark
                                ? AppColors.lightblack
                                : Colors.grey[100],
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
                              borderSide: const BorderSide(
                                  color: AppColors.orange, width: 1.5),
                            ),
                            contentPadding: const EdgeInsets.all(12),
                            errorStyle: const TextStyle(height: 0),
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
                    : (localizations.didntReceiveCode),
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
                  localizations.resendCode,
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
                    disabledBackgroundColor:
                        AppColors.orange.withValues(alpha: 0.5),
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
                          localizations.verifyCode,
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
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
