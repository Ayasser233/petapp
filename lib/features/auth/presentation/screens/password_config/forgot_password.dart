import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/services/api_client.dart';
import 'package:petapp/core/styles/input_styles.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  late final ApiClient _apiClient;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _apiClient = Get.find<ApiClient>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Validate email
  String? _validateEmail(String? value) {
    final localizations = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return localizations.pleaseEnterEmail;
    }
    if (!value.contains('@') || !value.contains('.')) {
      return localizations.pleaseEnterValidEmail;
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
    final localizations = AppLocalizations.of(context);

    setState(() {
      _isLoading = true;
    });

    try {
      // Call the forgot password API
      final response = await _apiClient.forgotPassword(email);

      // Check if the response is successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Navigate to verification screen
        Get.toNamed(AppRoutes.enterVerificationCode, arguments: email);

        // Show success message
        Get.snackbar(
          localizations.codeSent,
          localizations.verificationCodeSentTo(email),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
          duration: const Duration(seconds: 3),
        );
      }
    } on DioException catch (e) {
      // Handle API errors
      String errorMessage = localizations.failedToSendCode;
      String errorTitle = 'Error';
      bool isMailServerError = false;

      // Check for timeout errors
      if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        errorTitle = '⏱️ Timeout Error';
        errorMessage = 'Server is not responding. Please check:\n'
            '1. Backend server is running on port 3000\n'
            '2. Network connection is stable\n'
            '3. Backend logs for errors';
      }
      // Check for connection errors
      else if (e.type == DioExceptionType.connectionError) {
        errorTitle = '🔌 Connection Error';
        errorMessage = 'Cannot connect to server. Please ensure:\n'
            '1. Backend is running (npm start or npm run dev)\n'
            '2. Server is listening on port 3000\n'
            '3. No firewall blocking the connection';
      } else if (e.response != null) {
        // Uncomment when you want to bypass email service errors in development
        if (e.response?.statusCode == 500 &&
            e.response?.data != null &&
            e.response?.data['message'] != null &&
            (e.response?.data['message']
                    .toString()
                    .contains('ENOTFOUND maildev') ??
                false)) {
          isMailServerError = true;

          Get.toNamed(AppRoutes.enterVerificationCode, arguments: email);

          Get.snackbar(
            localizations.codeSent,
            localizations.verificationCodeSentTo(email),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withValues(alpha: 0.1),
            colorText: Colors.green,
            duration: const Duration(seconds: 3),
          );
        }

        // Check for 404 status code (no account found)
        if (e.response?.statusCode == 404) {
          errorMessage = localizations.noAccountFoundWithEmail;
        } else if (e.response?.data != null &&
            e.response?.data['message'] != null) {
          // Use the error message from the API
          errorMessage = e.response?.data['message'];
        }
      }

      // Only show error if it's not a mail server error
      if (!isMailServerError) {
        Get.snackbar(
          errorTitle,
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
          duration: const Duration(seconds: 6),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        localizations.failedToSendCode,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 4),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.resetYourPassword,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  localizations.enterRegisteredEmail,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                const SizedBox(height: 32.0),

                // Email Field (removed separate label)
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Iconsax.sms, color: AppColors.orange),
                    hintText: localizations.email,
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
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                    errorStyle: const TextStyle(height: 1.2),
                    errorMaxLines: 2,
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
                            localizations.sendVerificationCode,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
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
      ),
    );
  }
}
