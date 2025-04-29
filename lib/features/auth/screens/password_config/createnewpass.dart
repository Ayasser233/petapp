import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/widgets/success_dialog.dart'; // Import the SuccessDialog
import 'package:petapp/core/styles/input_styles.dart'; // Import the custom input style

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  _CreateNewPasswordScreenState createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final passwordFocusNode = FocusNode();
  final confirmFocusNode = FocusNode();
  bool obscure = true;
  bool error = false;

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    passwordFocusNode.dispose();
    confirmFocusNode.dispose();
    super.dispose();
  }

  void _validate() {
    if (passwordController.text.length < 6) {
      setState(() => error = true);
      return;
    }

    if (passwordController.text != confirmController.text) {
      setState(() => error = true);
      return;
    }

    setState(() => error = false);
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => SuccessDialog(
        title: 'Password Changed!',
        message: 'You can now log in with your new password.',
        buttonText: 'Login Now',
        onButtonPressed: () => Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => false,
        ),
        animationPath: 'assets/animations/success.json', // Optional Lottie animation
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton(), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create New Password',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              const Text('Set your new password below.'),
              const SizedBox(height: 30),
              Text('New Password', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: passwordController,
                obscureText: obscure,
                focusNode: passwordFocusNode,
                decoration: customInputDecoration('Enter New Password').copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => setState(() => obscure = !obscure),
                  ),
                  focusedBorder: focusedFieldStyle(),
                  filled: true,
                  fillColor: passwordFocusNode.hasFocus? AppColors.lightorange : AppColors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text('Confirm Password', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: confirmController,
                obscureText: obscure,
                focusNode: confirmFocusNode,
                decoration: customInputDecoration('Enter Password Again').copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => setState(() => obscure = !obscure),
                  ),
                  focusedBorder: focusedFieldStyle(),
                  filled: true,
                  fillColor: passwordFocusNode.hasFocus? AppColors.lightorange : AppColors.white,
                ),
              ),
              if (error)
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'Passwords must match and be at least 6 characters',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  _validate();
                  if (!error) {
                    _showSuccessDialog();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Create New Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
