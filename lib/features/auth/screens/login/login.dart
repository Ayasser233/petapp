import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/routes/routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: 56.0, left: 24.0, right: 24.0, bottom: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Text
              HeaderText(
                title: 'Welcome Back',
                subtitle: 'Login to your account',
              ),
              SizedBox(height: 32.0),
              // Add your login form here
              LoginForm(),
              // divider
              DividerForm(dividerText: 'Or continue with'),
              SizedBox(height: 16.0),
              // footer
              // Google & Apple Sign In Buttons - Vertical
              SocialBtns(),

              SignUpText(text: 'Don\'t have an account?', signUpText: ' Sign Up'),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpText extends StatelessWidget {
  final String text;
  final String signUpText;
  const SignUpText({
    required this.text,
    required this.signUpText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
          GestureDetector(
            onTap: () {
              // Navigate to Sign Up Screen
              Get.toNamed(AppRoutes.signUp);
            },
            child: Text(
              signUpText,
              style: const TextStyle(
                color: AppColors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SocialBtns extends StatelessWidget {
  const SocialBtns({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              // TODO: Handle Google Sign-in
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(color: Colors.grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icons/google.png',
                    width: 20, height: 20),
                const SizedBox(width: 8),
                Text('Sign in with Google',
                    style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              // TODO: Handle Apple Sign-in
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(color: Colors.grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.apple,
                    color: THelperFunctions.isDarkMode(context)
                        ? Colors.white
                        : Colors.black),
                const SizedBox(width: 8),
                Text('Sign in with Apple',
                    style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DividerForm extends StatelessWidget {
  const DividerForm({
    super.key,
    required this.dividerText,
  });

  final String dividerText;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
            child: Divider(
          color: dark ? AppColors.lightblack : Colors.grey,
          thickness: 0.5,
          indent: 60,
          endIndent: 5,
        )),
        Text('Or continue with', style: Theme.of(context).textTheme.bodySmall),
        Flexible(
            child: Divider(
          color: dark ? AppColors.lightblack : Colors.grey,
          thickness: 0.5,
          indent: 5,
          endIndent: 60,
        )),
      ],
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.user),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {},
                ),
                hintText: 'Enter your email',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.lock),
                suffixIcon: IconButton(
                  icon: const Icon(Iconsax.eye_slash),
                  onPressed: () {},
                ),
                hintText: 'Enter your password',
                border: const OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // remember me checkbox
                Row(
                  children: [
                    Checkbox(
                      value: true,
                      onChanged: (value) {},
                    ),
                    const Text('Remember me'),
                  ],
                ),
                // forgot password text
                TextButton(
                  onPressed: () {
                    // Navigate to Forgot Password Screen
                    Get.toNamed(AppRoutes.forgotPassword);
                  },
                  child: const Text('Forgot Password?'),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            // Sign In button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Handle Sign In Logic
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('Sign In', style: TextStyle(fontSize: 16.0)),
              ),
            ),
          ],
        ),
      ),
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
