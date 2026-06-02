/// App-wide constants.
///
/// ⚠️  Replace [supportWhatsAppNumber] with your real WhatsApp Business number
/// in E.164 format (digits only, no '+', no spaces, no dashes).
/// Example: '201234567890'  →  Egyptian number +20 123 456 7890
class AppConstants {
  AppConstants._();

  // ─── Support ──────────────────────────────────────────────────────────────

  /// WhatsApp Business number for customer support.
  /// Format: country code + number, no '+', e.g. '201234567890'
  ///
  /// ⚠️  Replace this placeholder with your real number before going live.
  static const String supportWhatsAppNumber = '201036036330';

  /// Default prefilled message sent when a customer opens WhatsApp support.
  static const String supportWhatsAppDefaultMessage =
      'Hello Aleefy support, I need help.';

  /// Support e-mail address.
  static const String supportEmail = 'support@aleefy-app.com';

  /// Default subject line for support e-mails.
  static const String supportEmailSubject = 'ALeefy Support Request';

  /// Default body for support e-mails.
  static const String supportEmailBody = 'Hello Aleefy support,\n\nI need help with:\n';
}
