import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:petapp/core/styles/input_styles.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/app_fonts.dart';
import 'package:petapp/core/routes/routes.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
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
              SizedBox(height: 24.0),
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
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Add listeners to text fields
    _nameController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _nameController.text.isNotEmpty ||
          _phoneController.text.isNotEmpty ||
          _emailController.text.isNotEmpty ||
          _passwordController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full Name Field
          Text('Full Name', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8.0),
          TextFormField(
            focusNode: _nameFocus,
            controller: _nameController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Iconsax.user),
              hintText: 'Enter your name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              focusedBorder: focusedFieldStyle(),
              filled: true,
              fillColor:
                  _nameFocus.hasFocus ? AppColors.lightorange : Colors.white,
            ),
          ),
          const SizedBox(height: 16.0),

          // Phone Number Field
          Text('Phone Number', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8.0),
          TextFormField(
            focusNode: _phoneFocus,
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 12.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('+1', style: TextStyle(fontSize: 14)),
                        Icon(Icons.arrow_drop_down, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
              hintText: 'Enter your number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              focusedBorder: focusedFieldStyle(),
              filled: true,
              fillColor:
                  _phoneFocus.hasFocus ? AppColors.lightorange : Colors.white,
            ),
          ),
          const SizedBox(height: 16.0),

          // Email Field
          Text('Email', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8.0),
          TextFormField(
            focusNode: _emailFocus,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: const Icon(Iconsax.sms),
              hintText: 'Enter your email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              focusedBorder: focusedFieldStyle(),
              filled: true,
              fillColor:
                  _emailFocus.hasFocus ? AppColors.lightorange : Colors.white,
            ),
          ),
          const SizedBox(height: 16.0),

          // Password Field
          Text('Password', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8.0),
          TextFormField(
            focusNode: _passwordFocus,
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              prefixIcon: const Icon(Iconsax.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Iconsax.eye_slash : Iconsax.eye,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              hintText: 'Enter your password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              focusedBorder: focusedFieldStyle(),
              filled: true,
              fillColor:
                  _passwordFocus.hasFocus ? AppColors.lightorange : Colors.white,
            ),
          ),
          const SizedBox(height: 32.0),

          // Sign Up Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isFormValid
                  ? () {
                      // Navigate to Verify Email Screen
                      Get.toNamed(AppRoutes.verifyEmail,
                          arguments: _emailController.text);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                disabledBackgroundColor: AppColors.lightorange,
                disabledForegroundColor: AppColors.white,
              ),
              child: const Text('Sign Up', style: TextStyle(fontSize: 16.0)),
            ),
          ),
        ],
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
