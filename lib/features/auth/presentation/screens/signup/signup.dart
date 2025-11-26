import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:petapp/core/services/auth_service.dart';
import 'package:petapp/core/styles/input_styles.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/app_fonts.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/widgets/phone_input_field.dart';
import 'package:petapp/core/utils/validation_utils.dart';
import 'package:petapp/core/models/country_code.dart';
import 'package:petapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:petapp/di/service_locator.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/utils/formatters.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 56.0, left: 24.0, right: 24.0, bottom: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Text
                HeaderText(
                  title: AppLocalizations.of(context).createAccount,
                  subtitle:
                      AppLocalizations.of(context).accountCreationSubtitle,
                ),
                const SizedBox(height: 32.0),
                // Add your sign-up form here
                const SignUpForm(),

                const SizedBox(height: 16.0),

                // Terms and Privacy Policy
                const TermsAndPrivacyText(),

                const SizedBox(height: 24.0),

                // Sign In Link
                LoginText(
                    text: AppLocalizations.of(context).alreadyHaveAccount,
                    loginText: " ${AppLocalizations.of(context).signIn}"),

                // Skip signup button
                const SkipSignupButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _obscurePassword = true;
  bool _isFormValid = false;

  final _formKey = GlobalKey<FormState>(); // Add a form key for validation
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  CountryCode _selectedCountry = CountryCodes.commonCodes.first;

  // Add these variables to track field errors
  String? _firstNameError;
  String? _lastNameError;
  String? _phoneError;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();

    // Add listeners to text fields
    _firstNameController.addListener(_checkFormValidity);
    _lastNameController.addListener(_checkFormValidity);
    _phoneController.addListener(_checkFormValidity);
    _emailController.addListener(_checkFormValidity);
    _passwordController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Check form validity
  void _checkFormValidity() {
    final isValid = _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _phoneController.text.length >=
            10 && // Phone should be at least 10 digits
        _emailController.text.isNotEmpty &&
        _emailController.text.contains('@') &&
        _passwordController.text.isNotEmpty &&
        _passwordController.text.length >= 6;

    setState(() {
      _isFormValid = isValid;
    });
  }

  // Handle sign up
  Future<void> _handleSignUp() async {
    // Validate the form - this will show errors if any
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    // Check if widget is still mounted before using context
    if (!mounted) return;

    // Prepare data for new API format
    final Map<String, dynamic> userData = {
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'email': _emailController.text.trim(),
      'password': _passwordController.text,
      'mobile':
          '${_selectedCountry.dialCode}${TFormatter.toEnglishNumerals(_phoneController.text)}',
    };

    // Use the cubit to register
    context.read<AuthCubit>().register(userData);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // Reset field errors
        setState(() {
          _firstNameError = null;
          _lastNameError = null;
          _phoneError = null;
          _emailError = null;
          _passwordError = null;
        });

        if (state is AuthRegistrationSuccess) {
          // Clear any previous field errors

          // Show appropriate message based on whether there's a mail service error
          if (state.isMailServiceError) {
            Get.snackbar(
              AppLocalizations.of(context).registrationSuccessful,
              '${AppLocalizations.of(context).pleaseVerifyEmail}\n(Email service temporarily unavailable)',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orange.withValues(alpha: 0.1),
              colorText: Colors.orange,
              borderRadius: 8,
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 4),
            );
          } else {
            // Show success message
            Get.snackbar(
              AppLocalizations.of(context).registrationSuccessful,
              AppLocalizations.of(context).pleaseVerifyEmail,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withValues(alpha: 0.1),
              colorText: Colors.green,
              borderRadius: 8,
              margin: const EdgeInsets.all(16),
            );
          }

          // Navigate to verification screen
          Get.toNamed(AppRoutes.verifyEmail, arguments: state.email);
        } else if (state is AuthFailure) {
          // Handle field-specific errors if available
          if (state.fieldErrors != null && state.fieldErrors!.isNotEmpty) {
            setState(() {
              _firstNameError = state.fieldErrors!['firstName'];
              _lastNameError = state.fieldErrors!['lastName'];
              _phoneError = state.fieldErrors!['mobile'];
              _emailError = state.fieldErrors!['email'];
              _passwordError = state.fieldErrors!['password'];
            });
          }

          // Show error message
          Get.snackbar(
            AppLocalizations.of(context).registrationFailed,
            state.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withValues(alpha: 0.1),
            colorText: Colors.red,
            borderRadius: 8,
            margin: const EdgeInsets.all(16),
            duration:
                const Duration(seconds: 5), // Give more time to read errors
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Name field
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.user, color: AppColors.orange),
                  hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[400],
                      ),
                  hintText: AppLocalizations.of(context).firstName,
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
                  filled: true,
                  fillColor: isDark ? AppColors.lightblack : Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  errorStyle: const TextStyle(height: 0.8),
                  errorText: _firstNameError,
                ),
                autovalidateMode: AutovalidateMode.disabled,
                validator: ValidationUtils.validateName,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                onChanged: (value) {
                  setState(() {
                    _firstNameError = null;
                  });
                },
              ),
              const SizedBox(height: 16.0),

              // Last Name field
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.user, color: AppColors.orange),
                  hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[400],
                      ),
                  hintText: AppLocalizations.of(context).lastName,
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
                  filled: true,
                  fillColor: isDark ? AppColors.lightblack : Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  errorStyle: const TextStyle(height: 0.8),
                  errorText: _lastNameError,
                ),
                autovalidateMode: AutovalidateMode.disabled,
                validator: ValidationUtils.validateName,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                onChanged: (value) {
                  setState(() {
                    _lastNameError = null;
                  });
                },
              ),
              const SizedBox(height: 16.0),

              // Phone Number Field with country code
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: isDark ? AppColors.lightblack : Colors.grey[100],
                  border: _phoneError != null
                      ? Border.all(color: Colors.red)
                      : null,
                ),
                child: PhoneInputField(
                  controller: _phoneController,
                  isDark: isDark,
                  hintText: AppLocalizations.of(context).phoneNumber,
                  // errorText: _phoneError,
                  onChanged: (phone, country) {
                    setState(() {
                      _selectedCountry = country;
                      _phoneError = null; // Clear error on change
                    });
                    _checkFormValidity();
                  },
                ),
              ),
              if (_phoneError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6.0, left: 12.0),
                  child: Text(
                    _phoneError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 16.0),

              // Email field with custom error
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.disabled,
                decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Iconsax.sms, color: AppColors.orange),
                    hintText: AppLocalizations.of(context).email,
                    hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[400],
                        ),
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
                    filled: true,
                    fillColor: isDark ? AppColors.lightblack : Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                    errorStyle: const TextStyle(height: 0.8),
                    errorText: _emailError),
                validator: ValidationUtils.validateEmail,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                // Show API-specific errors
                onChanged: (value) {
                  setState(() {
                    _emailError = null;
                  });
                },
              ),
              const SizedBox(height: 16.0),

              // Password field with custom error
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                autovalidateMode: AutovalidateMode.disabled,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.lock, color: AppColors.orange),
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
                  hintText: AppLocalizations.of(context).password,
                  hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[400],
                      ),
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
                  filled: true,
                  fillColor: isDark ? AppColors.lightblack : Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  errorStyle: const TextStyle(height: 0.8),
                  errorText: _passwordError,
                ),
                validator: ValidationUtils.validatePassword,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                // Show API-specific errors
                onChanged: (value) {
                  setState(() {
                    _passwordError = null;
                  });
                },
              ),
              const SizedBox(height: 32.0),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                child: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final bool isLoading = state is AuthLoading;

                    return ElevatedButton(
                      onPressed:
                          isLoading || !_isFormValid ? null : _handleSignUp,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: AppColors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        disabledBackgroundColor:
                            AppColors.orange.withValues(alpha: 0.5),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.0,
                              ),
                            )
                          : Text(
                              AppLocalizations.of(context).signUp,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TermsAndPrivacyText extends StatelessWidget {
  const TermsAndPrivacyText({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(context).textTheme.labelSmall,
          children: [
            TextSpan(
                text: '${localizations.termsAndConditionsAgreement} ',
                style: Theme.of(context).textTheme.labelLarge),
            TextSpan(
              text: localizations.termsAndConditions,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.orange,
                    fontWeight: AppFonts.semiBold,
                  ),
            ),
            TextSpan(
                text: ' ${localizations.and} ',
                style: Theme.of(context).textTheme.labelLarge),
            TextSpan(
              text: localizations.privacyPolicy,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.orange,
                    fontWeight: AppFonts.semiBold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginText extends StatelessWidget {
  final String text;
  final String loginText;
  const LoginText({
    required this.text,
    required this.loginText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
        GestureDetector(
          onTap: () {
            // Navigate to Login Screen
            Get.toNamed(AppRoutes.login);
          },
          child: Text(
            loginText,
            style: const TextStyle(
              color: AppColors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}

// Header Text
class HeaderText extends StatelessWidget {
  final String title, subtitle;
  const HeaderText({
    super.key,
    required this.title,
    required this.subtitle,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 10.0),
        Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

// Skip Signup Button
class SkipSignupButton extends StatelessWidget {
  const SkipSignupButton({super.key});

  void _skipSignup() async {
    final AuthService authService = Get.find<AuthService>();
    await authService.setGuestMode();
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Center(
        child: TextButton(
          onPressed: _skipSignup,
          child: Text(
            AppLocalizations.of(context).skipSignup,
            style: const TextStyle(
              color: AppColors.orange,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }
}


