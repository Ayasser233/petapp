import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/services/api_client.dart';
import 'package:petapp/core/services/auth_service.dart';
import 'package:petapp/core/services/token_service.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/arabic_numeral_formatter.dart';
import 'package:petapp/core/utils/formatters.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/widgets/success_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key, required String email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  // Controllers for OTP fields (6 digits)
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());

  // Focus nodes for each field
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  late final ApiClient _apiClient;
  bool _isLoading = false;
  int _resendTimer = 60; // 60 seconds countdown
  Timer? _timer;
  String? _errorMessage;
  late final String _email;

  @override
  void initState() {
    super.initState();
    _apiClient = Get.find<ApiClient>();
    _email = Get.arguments ?? '';
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

      // Call the resend OTP API (for email verification)
      final response = await _apiClient.resendOtp(_email);

      // Check if the response is successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Reset fields
        for (final controller in _controllers) {
          controller.clear();
        }

        // Reset timer
        setState(() {
          _resendTimer = 60;
        });
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

      Get.snackbar(
        localizations.error,
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
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

  // Handle email verification
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
      // Call the confirm email API
      final response = await _apiClient.confirmEmail(_email, enteredCode);

      // Check if the response is successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Check if user has tokens (came from login) or not (came from signup)
        final tokenService = Get.find<TokenService>();
        final hasToken = await tokenService.getToken();

        if (hasToken != null && hasToken.isNotEmpty) {
          // User came from login - they already have tokens, go to home
          final authService = Get.find<AuthService>();
          authService.setAuthenticated();
          await authService.clearGuestMode();

          // Set login flag
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);

          // Show success dialog and navigate to home
          if (mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => SuccessDialog(
                title: localizations.emailVerifiedSuccessfully,
                message: localizations.youCanNowContinueToTheApp,
                buttonText: localizations.continueText,
                animationPath: 'assets/animations/success.json',
                onButtonPressed: () {
                  Get.offAllNamed(AppRoutes.home);
                },
              ),
            );
          }
        } else {
          // User came from signup - no tokens yet, go to login
          if (mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => SuccessDialog(
                title: localizations.emailVerifiedSuccessfully,
                message: localizations.youCanNowContinueToTheApp,
                buttonText: localizations.continueText,
                animationPath: 'assets/animations/success.json',
                onButtonPressed: () {
                  Get.offAllNamed(AppRoutes.login);
                },
              ),
            );
          }
        }
      }
    } on DioException catch (e) {
      String errorMessage = localizations.verificationFailed;

      // Handle specific error codes
      if (e.response?.statusCode == 400) {
        errorMessage = localizations.invalidOrExpiredCode;
      } else if (e.response != null &&
          e.response?.data != null &&
          e.response?.data['message'] != null) {
        errorMessage = e.response?.data['message'];
      }

      setState(() {
        _errorMessage = errorMessage;
      });

      Get.snackbar(
        localizations.verificationFailed,
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } catch (e) {
      setState(() {
        _errorMessage = localizations.verificationFailed;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isDark = THelperFunctions.isDarkMode(context);

    return PopScope(
      canPop: false, // Prevent back navigation
      onPopInvokedWithResult: (didPop, result) {
        // Show a message when user tries to go back
        if (!didPop) {
          Get.snackbar(
            localizations.emailNotVerified,
            localizations.pleaseVerifyYourEmail,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange.withValues(alpha: 0.1),
            colorText: AppColors.orange,
            duration: const Duration(seconds: 2),
          );
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: isDark ? Colors.black : Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false, // Remove back button
        ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Animation
            Lottie.asset(
              'assets/animations/mailsent.json',
              height: 150,
              width: 150,
              repeat: false,
            ),
            const SizedBox(height: 32),

            // Title
            Text(
              localizations.verifyYourEmail,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Email subtitle
            Text(
              _email,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.orange,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              localizations.enterThe6DigitCodeSentTo(_email),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // OTP Input Fields
            Builder(
              builder: (context) {
                final isArabic =
                    Localizations.localeOf(context).languageCode == 'ar';
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 50,
                      height: 60,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor:
                              isDark ? Colors.grey[850] : Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDark
                                  ? Colors.grey[700]!
                                  : Colors.grey[300]!,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDark
                                  ? Colors.grey[700]!
                                  : Colors.grey[300]!,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.orange,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Colors.red, width: 2),
                          ),
                        ),
                        inputFormatters: [
                          ArabicAwareDigitsOnlyFormatter(),
                          ArabicNumeralInputFormatter(isArabic),
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            // Move to next field
                            if (index < 5) {
                              _focusNodes[index + 1].requestFocus();
                            } else {
                              // Last field, remove focus
                              _focusNodes[index].unfocus();
                            }
                          } else if (value.isEmpty && index > 0) {
                            // Move to previous field on backspace
                            _focusNodes[index - 1].requestFocus();
                          }

                          // Clear error when user types
                          if (_errorMessage != null) {
                            setState(() {
                              _errorMessage = null;
                            });
                          }
                        },
                      ),
                    );
                  }),
                );
              },
            ),

            const SizedBox(height: 16),

            // Error message
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 32),

            // Verify Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleVerification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        localizations.verify,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 24),

            // Resend Code
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  localizations.didntReceiveCode,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                ),
                const SizedBox(width: 4),
                TextButton(
                  onPressed: _resendTimer == 0 && !_isLoading
                      ? _handleResendCode
                      : null,
                  child: Text(
                    _resendTimer > 0
                        ? '${localizations.resendCode} ($_resendTimer${localizations.seconds})'
                        : localizations.resendCode,
                    style: TextStyle(
                      color: _resendTimer == 0
                          ? AppColors.orange
                          : (isDark ? Colors.grey[600] : Colors.grey[400]),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      ), // Close PopScope
    );
  }
}
