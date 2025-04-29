import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final String? animationPath; // Optional Lottie animation path

  const SuccessDialog({
    super.key,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onButtonPressed,
    this.animationPath, // Optional animation
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (animationPath != null)
            Lottie.asset(
              animationPath!,
              repeat: false,
              width: 100,
              height: 100,
            )
          else
            const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
          const SizedBox(height: 20),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onButtonPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}