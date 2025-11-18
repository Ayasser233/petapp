class TurnstileConfig {
  // Production key - Make sure to configure Cloudflare for mobile app usage!
  // See docs/turnstile_error_110200_fix.md for setup instructions
  static const String siteKey = '0x4AAAAAACA2gzj8NdJAxTOh';

  // BACKUP: If you get error 110200, temporarily use test key for development:
  // static const String siteKey = '1x00000000000000000000AA';
  // NOTE: Test keys require test secret key on backend!

  // Secret key (BACKEND ONLY - keep this private!):
  // 0x4AAAAAACA2g-fDWOWon9f4XvSyCnqy8rc
}
