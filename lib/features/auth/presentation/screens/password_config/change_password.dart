import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/styles/input_styles.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/services/api_client.dart';
import 'package:iconsax/iconsax.dart';
import 'package:dio/dio.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  late final ApiClient _apiClient;

  @override
  void initState() {
    super.initState();
    _apiClient = Get.find<ApiClient>();
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Validate current password
  String? _validateCurrentPassword(String? value) {
    final localizations = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return localizations.pleaseEnterPassword;
    }
    return null;
  }

  // Validate new password
  String? _validateNewPassword(String? value) {
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
    // Check if new password is same as current password
    if (value == currentPasswordController.text) {
      return localizations.newPasswordMustBeDifferent;
    }
    return null;
  }

  // Validate confirm password
  String? _validateConfirmPassword(String? value) {
    final localizations = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return localizations.pleaseConfirmPassword;
    }
    if (value != newPasswordController.text) {
      return localizations.passwordsDoNotMatch;
    }
    return null;
  }

  // Handle change password
  Future<void> _handleChangePassword() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Capture BuildContext-dependent values before async gap
    final localizations = AppLocalizations.of(context);
    final navigator = Navigator.of(context);

    try {
      // Call the change password API
      final response = await _apiClient.changePassword(
        currentPasswordController.text,
        newPasswordController.text,
      );

      // Check if the response is successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Show success snackbar
        Get.snackbar(
          localizations.success,
          localizations.passwordChangedMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.check_circle, color: Colors.white),
          margin: const EdgeInsets.all(16),
        );

        // Wait a moment for the snackbar to show, then navigate back
        await Future.delayed(const Duration(milliseconds: 2000));

        // Check if mounted before navigation
        if (mounted) {
          // Use captured navigator to avoid BuildContext across async gap
          if (navigator.canPop()) {
            navigator.pop();
          } else {
            Get.back();
          }
        }
      } else {
        // Handle unexpected success status codes
        throw Exception('Unexpected response status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      String errorMessage = localizations.failedToResetPassword;

      // Handle specific error codes
      if (e.response != null &&
          e.response?.data != null &&
          e.response?.data['message'] != null) {
        errorMessage = e.response?.data['message'];
      } else if (e.response?.statusCode == 401) {
        errorMessage = 'Current password is incorrect';
      }

      if (mounted) {
        Get.snackbar(
          localizations.error,
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.error_outline, color: Colors.white),
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          localizations.error,
          localizations.failedToResetPassword,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.error_outline, color: Colors.white),
          margin: const EdgeInsets.all(16),
        );
      }
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
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        title: Text(
          localizations.changePassword,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.changePassword,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  localizations.enterCurrentPasswordPrompt,
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

                // Current Password Field
                TextFormField(
                  controller: currentPasswordController,
                  obscureText: _obscureCurrentPassword,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Iconsax.lock, color: AppColors.orange),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureCurrentPassword
                            ? Iconsax.eye_slash
                            : Iconsax.eye,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureCurrentPassword = !_obscureCurrentPassword;
                        });
                      },
                    ),
                    hintText: localizations.currentPassword,
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
                  validator: _validateCurrentPassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                ),
                const SizedBox(height: 16.0),

                // New Password Field
                TextFormField(
                  controller: newPasswordController,
                  obscureText: _obscureNewPassword,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Iconsax.lock, color: AppColors.orange),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPassword ? Iconsax.eye_slash : Iconsax.eye,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
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
                    errorStyle: const TextStyle(height: 1.2),
                    errorMaxLines: 2,
                  ),
                  validator: _validateNewPassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                ),
                const SizedBox(height: 16.0),

                // Confirm Password Field
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Iconsax.lock, color: AppColors.orange),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Iconsax.eye_slash
                            : Iconsax.eye,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
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
                    errorStyle: const TextStyle(height: 1.2),
                    errorMaxLines: 2,
                  ),
                  validator: _validateConfirmPassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                ),

                const SizedBox(height: 32.0),

                // Change Password Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleChangePassword,
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
                            localizations.changePassword,
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
