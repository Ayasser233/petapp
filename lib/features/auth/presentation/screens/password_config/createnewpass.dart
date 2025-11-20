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
import 'package:petapp/core/widgets/success_dialog.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateNewPasswordScreenState createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  late final ApiClient _apiClient;

  // Get email and resetToken from previous screen arguments
  // The arguments are passed as a Map with 'email' and 'resetToken' keys
  late final String _email;
  late final String _resetToken;

  @override
  void initState() {
    super.initState();
    _apiClient = Get.find<ApiClient>();
    // Get arguments (email and resetToken from verification screen)
    final args = Get.arguments;
    if (args is Map) {
      _email = args['email'] ?? '';
      _resetToken = args['resetToken'] ?? '';
    } else if (args is String) {
      // Fallback: if only email is passed as string
      _email = args;
      _resetToken = '';
    } else {
      _email = '';
      _resetToken = '';
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  // Validate password
  String? _validatePassword(String? value) {
    final localizations = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return localizations.pleaseEnterPassword;
    }
    if (value.length < 6) {
      return localizations.passwordMustBeAtLeast6Characters;
    }
    // Check for at least one uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return localizations.passwordMustContainUppercase;
    }
    // Check for at least one digit
    if (!value.contains(RegExp(r'[0-9]'))) {
      return localizations.passwordMustContainNumber;
    }
    return null;
  }

  // Validate confirm password
  String? _validateConfirmPassword(String? value) {
    final localizations = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return localizations.pleaseConfirmPassword;
    }
    if (value != passwordController.text) {
      return localizations.passwordsDoNotMatch;
    }
    return null;
  }

  // Handle reset password
  Future<void> _handleResetPassword() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Call the reset password API with resetToken
      final response = await _apiClient.resetPassword(
        _email,
        _resetToken,
        passwordController.text,
      );

      // Check if the response is successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Show success dialog
        _showSuccessDialog();
      }
    } on DioException catch (e) {
      final localizations = AppLocalizations.of(context);
      String errorMessage = localizations.failedToResetPassword;

      // Handle specific error codes
      if (e.response != null &&
          e.response?.data != null &&
          e.response?.data['message'] != null) {
        errorMessage = e.response?.data['message'];
      }

      Get.snackbar(
        localizations.errorVerifyingCode,
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      final localizations = AppLocalizations.of(context);
      Get.snackbar(
        localizations.errorVerifyingCode,
        localizations.failedToResetPassword,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog() {
    final localizations = AppLocalizations.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SuccessDialog(
        title: localizations.passwordResetSuccessfully,
        message: localizations.passwordChangedMessage,
        buttonText: localizations.loginNow,
        onButtonPressed: () => Get.offAllNamed(AppRoutes.login),
        animationPath: 'assets/animations/success.json',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        title: Text(
          localizations.createNewPassword,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
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
                  localizations.createNewPassword,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  localizations.newPasswordMustBeDifferent,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                const SizedBox(height: 32.0),

                // Password strength indicators
                Row(
                  children: [
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      localizations.atLeast6Characters,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      localizations.containsANumber,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      localizations.containsAnUppercaseLetter,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),

                // Password Field
                TextFormField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Iconsax.lock, color: AppColors.orange),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Iconsax.eye_slash : Iconsax.eye,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    hintText: localizations.newPassword,
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
                    errorStyle: const TextStyle(height: 0.8),
                  ),
                  validator: _validatePassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                ),
                const SizedBox(height: 16.0),

                // Confirm Password Field
                TextFormField(
                  controller: confirmController,
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Iconsax.lock, color: AppColors.orange),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm ? Iconsax.eye_slash : Iconsax.eye,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirm = !_obscureConfirm;
                        });
                      },
                    ),
                    hintText: localizations.confirmPassword,
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
                    errorStyle: const TextStyle(height: 0.8),
                  ),
                  validator: _validateConfirmPassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                ),

                const SizedBox(height: 32),

                // Reset Password Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleResetPassword,
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
                            localizations.resetPassword,
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
