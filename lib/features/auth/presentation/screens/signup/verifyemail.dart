import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:petapp/core/widgets/success_dialog.dart'; // Import the SuccessDialog

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, required String email});

  @override
  Widget build(BuildContext context) {
    // You might want to pass the email address to this screen
    final String? email = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove default back arrow
        actions: [
          IconButton(
              onPressed: () => Get.offAllNamed('/login'), // Navigate to login
              icon: const Icon(Icons.clear))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0), // Use a consistent padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Spacer(flex: 2), // Spacer to center the content vertically
            Lottie.asset(
              'assets/animations/mailsent.json', // Path to your Lottie file
              height: 200,
              width: 200,
              repeat: false,
            ),
            const SizedBox(height: 24.0), // Use consistent spacing

            // Title
            Text(
              "Verify your email address!",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),

            // Subtitle with email (if available)
            Text(
              email ?? 'example@example.com', // Display the email if passed
              style: Theme.of(context).textTheme.labelLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),

            // Message
            Text(
              "We have sent a verification email to your inbox. Please check your email and click on the link to verify your account.",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32.0),

            // Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => SuccessDialog(
                      title: "Email Verified Successfully!",
                      message: "You can now continue to the app.",
                      buttonText: "Continue",
                      animationPath: 'assets/animations/success.json',
                      onButtonPressed: () {
                        Get.offAllNamed('/home'); // Navigate to Home or Login
                      },
                    ),
                  );
                },
                child: const Text("Continue"),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                // TODO: Implement resend email logic
                onPressed: () {},
                child: Text("Resend Email", style: Theme.of(context).textTheme.labelLarge),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
