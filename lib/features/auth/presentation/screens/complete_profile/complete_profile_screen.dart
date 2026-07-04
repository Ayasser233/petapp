import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/services/auth_service.dart';
import 'package:petapp/core/services/token_service.dart';
import 'package:petapp/core/styles/input_styles.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/utils/validation_utils.dart';
import 'package:petapp/di/service_locator.dart';
import 'package:petapp/features/auth/data/models/user_model.dart';
import 'package:petapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  late final UserModel _user;
  late final String _token;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    _user = args['user'] as UserModel;
    _token = args['token'] as String;

    _nameController.text = _user.name;
    if (_nameController.text.toLowerCase() == 'user') {
      _nameController.clear();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // ✅ Fix: استقبل ctx من BlocBuilder
  void _handleSubmit(BuildContext ctx) {
    if (_formKey.currentState!.validate()) {
      final normalizePhone = ValidationUtils.normalizePhone(_phoneController.text.trim());
      ctx.read<AuthCubit>().completeProfile(
        _nameController.text.trim(),
        normalizePhone!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final l10n = AppLocalizations.of(context);

    return BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.completeProfile),
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) async {
            if (state is AuthProfileUpdateSuccess) {
              final authService = Get.find<AuthService>();
              final tokenService = Get.find<TokenService>();

              await tokenService.saveToken(_token);
              authService.setAuthenticated();

              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', true);

              Get.offAllNamed(AppRoutes.home);

              Get.snackbar(
                l10n.success,
                l10n.profileUpdatedSuccessfully,
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green.withValues(alpha: 0.1),
                colorText: Colors.green,
              );
            } else if (state is AuthFailure) {
              Get.snackbar(
                l10n.error,
                state.message,
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red.withValues(alpha: 0.1),
                colorText: Colors.red,
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.justAFewMoreDetails,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.completeProfileSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Name Field
                  Text(l10n.fullName,
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      prefixIcon:
                      const Icon(Iconsax.user, color: AppColors.orange),
                      hintText: l10n.enterFullName,
                      filled: true,
                      fillColor:
                      isDark ? AppColors.lightblack : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: focusedFieldStyle(),
                    ),
                    validator: (value) => ValidationUtils.validateFullName(
                        value, l10n.nameRequired, l10n.fullNameRequired),
                  ),
                  const SizedBox(height: 20),

                  // Phone Field
                  Text(l10n.phoneNumber,
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixIcon:
                      const Icon(Iconsax.call, color: AppColors.orange),
                      hintText: '+20 123 456 7890',
                      filled: true,
                      fillColor:
                      isDark ? AppColors.lightblack : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: focusedFieldStyle(),
                    ),
                    validator: ValidationUtils.validatePhone,
                  ),
                  const SizedBox(height: 40),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (ctx, state) {
                        // ✅ استخدم ctx مش context
                        final isLoading = state is AuthLoading;
                        return ElevatedButton(
                          onPressed:
                          isLoading ? null : () => _handleSubmit(ctx),
                          // ✅ مرر ctx هنا
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: AppColors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                              : Text(
                            l10n.submit,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
