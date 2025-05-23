import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:petapp/core/styles/input_styles.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/app_fonts.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/widgets/phone_input_field.dart';
import 'package:petapp/core/utils/validation_utils.dart';
import 'package:petapp/core/models/country_code.dart';
import 'package:petapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:petapp/di/service_locator.dart'; // Assuming you'll create this for DI

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: const Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.only(top: 56.0, left: 24.0, right: 24.0, bottom: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Text
                HeaderText(
                  title: 'Create Your Account',
                  subtitle:
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                ),
                SizedBox(height: 32.0),
                // Add your sign-up form here
                SignUpForm(),

                SizedBox(height: 16.0),

                // Terms and Privacy Policy
                TermsAndPrivacyText(),

                SizedBox(height: 24.0),

                // Sign In Link
                LoginText(
                    text: 'Already have an account?', loginText: ' Sign In'),
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
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  CountryCode _selectedCountry = CountryCodes.commonCodes.first;

  @override
  void initState() {
    super.initState();

    // Add listeners to text fields
    _nameController.addListener(_checkFormValidity);
    _phoneController.addListener(_checkFormValidity);
    _emailController.addListener(_checkFormValidity);
    _passwordController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Check form validity
  void _checkFormValidity() {
    final isValid = _nameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _emailController.text.contains('@') &&
        _passwordController.text.isNotEmpty &&
        _passwordController.text.length >= 6;
        
    setState(() {
      _isFormValid = isValid;
    });
  }

  // Handle sign up
  void _handleSignUp() {
    // First validate the form
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    // Prepare data for API with the country code
    final Map<String, dynamic> userData = {
      'username': _nameController.text,
      'mobileNumber': '${_selectedCountry.dialCode}${_phoneController.text}',
      'email': _emailController.text,
      'password': _passwordController.text,
      'role': 'user',
    };

    // Use the cubit to register
    context.read<AuthCubit>().register(userData);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthRegistrationSuccess) {
          // Show success message
          Get.snackbar(
            'Registration Successful',
            'Please verify your email to continue',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green,
            borderRadius: 8,
            margin: const EdgeInsets.all(16),
          );

          // Navigate to verification screen
          Get.toNamed(AppRoutes.verifyEmail, arguments: state.email);
        } else if (state is AuthFailure) {
          // Show error message
          Get.snackbar(
            'Registration Failed',
            state.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.1),
            colorText: Colors.red,
            borderRadius: 8,
            margin: const EdgeInsets.all(16),
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
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.user, color: AppColors.orange),
                  hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[400],
                      ),
                  hintText: 'Full Name',
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
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: ValidationUtils.validateName,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.white : Colors.black,
                    ),
              ),
              const SizedBox(height: 16.0),

              // Phone Number Field with country code
              PhoneInputField(
                controller: _phoneController,
                isDark: isDark,
                hintText: 'Phone Number',
                onChanged: (phone, country) {
                  setState(() {
                    _selectedCountry = country;
                  });
                  _checkFormValidity();
                },
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.sms, color: AppColors.orange),
                  hintText: 'Email',
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
                ),
                validator: ValidationUtils.validateEmail,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.white : Colors.black,
                    ),
              ),
              const SizedBox(height: 16.0),
          
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  hintText: 'Password',
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
                ),
                validator: ValidationUtils.validatePassword,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.white : Colors.black,
                    ),
              ),
              const SizedBox(height: 32.0),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                child: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final bool isLoading = state is AuthLoading;
                    
                    return ElevatedButton(
                      onPressed: isLoading || !_isFormValid ? null : _handleSignUp,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: AppColors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        disabledBackgroundColor: AppColors.orange.withOpacity(0.5),
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
                              'Sign Up',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: Colors.white, fontWeight: FontWeight.w600),
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
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(context).textTheme.labelSmall,
          children: [
            TextSpan(
                text: 'By registering you agree to ',
                style: Theme.of(context).textTheme.labelLarge),
            TextSpan(
              text: 'Terms & Conditions',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.orange,
                    fontWeight: AppFonts.semiBold,
                  ),
            ),
            TextSpan(
                text: ' and ', style: Theme.of(context).textTheme.labelLarge),
            TextSpan(
              text: 'Privacy Policy',
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
