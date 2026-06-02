import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:petapp/core/utils/app_constants.dart';

/// Handles launching the WhatsApp support conversation.
///
/// Strategy:
///   1. Try the `whatsapp://send` deep-link (opens the native WhatsApp app).
///   2. Fall back to `https://wa.me/` (opens in browser or WhatsApp Web).
///   3. If both fail, show a friendly snackbar.
///
/// Usage:
/// ```dart
/// await WhatsAppLauncherService.openSupportChat(context: context);
/// // or with a custom message:
/// await WhatsAppLauncherService.openSupportChat(
///   context: context,
///   prefilledMessage: 'Hi, I have a question about my appointment.',
/// );
/// ```
class WhatsAppLauncherService {
  WhatsAppLauncherService._(); // pure static utility — no instances needed

  /// Opens WhatsApp with [AppConstants.supportWhatsAppNumber] pre-selected.
  ///
  /// [prefilledMessage] defaults to [AppConstants.supportWhatsAppDefaultMessage].
  /// Pass [context] so the fallback snackbar can be displayed.
  ///
  /// If you later want to inject the user's name / phone into the message,
  /// just build the string before calling this method and pass it here.
  static Future<void> openSupportChat({
    required BuildContext context,
    String? prefilledMessage,
  }) async {
    const number = AppConstants.supportWhatsAppNumber;
    final message = Uri.encodeComponent(
      prefilledMessage ?? AppConstants.supportWhatsAppDefaultMessage,
    );

    // 1️⃣  Native WhatsApp deep-link
    final nativeUri = Uri.parse('whatsapp://send?phone=$number&text=$message');

    // 2️⃣  Web fallback (also opens WhatsApp app via app-link on mobile)
    final webUri =
        Uri.parse('https://wa.me/$number?text=$message');

    bool launched = false;

    try {
      if (await canLaunchUrl(nativeUri)) {
        launched = await launchUrl(nativeUri);
      }
    } catch (_) {
      launched = false;
    }

    if (!launched) {
      try {
        launched = await launchUrl(
          webUri,
          mode: LaunchMode.externalApplication,
        );
      } catch (_) {
        launched = false;
      }
    }

    if (!launched && context.mounted) {
      _showError(context);
    }
  }

  static void _showError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Unable to open WhatsApp right now. Please try again later.',
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // ─── Email ───────────────────────────────────────────────────────────────────

  /// Opens the device's default mail app with [AppConstants.supportEmail]
  /// pre-filled as the recipient, subject, and body.
  static Future<void> openSupportEmail({
    required BuildContext context,
    String? subject,
    String? body,
  }) async {
    // Uri(queryParameters:{}) uses '+' for spaces (form-encoding).
    // mailto: requires '%20', so encode manually and parse as a raw string.
    final encodedSubject = Uri.encodeComponent(
      subject ?? AppConstants.supportEmailSubject,
    );
    final encodedBody = Uri.encodeComponent(
      body ?? AppConstants.supportEmailBody,
    );

    final emailUri = Uri.parse(
      'mailto:${AppConstants.supportEmail}'
      '?subject=$encodedSubject'
      '&body=$encodedBody',
    );

    bool launched = false;
    try {
      // Skip canLaunchUrl — it returns false for mailto: on many Android
      // devices even when a mail app is installed. Call launchUrl directly.
      launched = await launchUrl(emailUri);
    } catch (_) {
      launched = false;
    }

    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Unable to open the mail app right now. Please try again later.',
          ),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }
}
