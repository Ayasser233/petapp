import 'dart:io';

class MapUrlUtils {
  MapUrlUtils._();

  /// Try to extract (lat,lng) from a google maps url.
  ///
  /// Supported patterns (direct):
  /// - https://www.google.com/maps?q=30.1,31.2
  /// - https://www.google.com/maps/search/?api=1&query=30.1,31.2
  /// - https://www.google.com/maps/@30.1,31.2,15z
  /// - ...?ll=30.1,31.2
  ///
  /// Not supported without network expansion:
  /// - https://maps.app.goo.gl/<short>
  static (double, double)? tryParseLatLngFromUrl(String url) {
    try {
      final uri = Uri.tryParse(url);
      if (uri == null) return null;

      for (final key in const ['q', 'query', 'll']) {
        final raw = uri.queryParameters[key];
        final coords = _tryParseLatLngPair(raw);
        if (coords != null) return coords;
      }

      final matchAt = RegExp(r'@(-?\d+(?:\.\d+)?),(-?\d+(?:\.\d+)?)')
          .firstMatch(url);
      if (matchAt != null) {
        final a = double.tryParse(matchAt.group(1)!);
        final b = double.tryParse(matchAt.group(2)!);
        if (a != null && b != null) return (a, b);
      }

      final matchAny = RegExp(r'(-?\d+(?:\.\d+)?),\s*(-?\d+(?:\.\d+)?)')
          .firstMatch(url);
      if (matchAny != null) {
        final a = double.tryParse(matchAny.group(1)!);
        final b = double.tryParse(matchAny.group(2)!);
        if (a != null && b != null) return (a, b);
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  static (double, double)? _tryParseLatLngPair(String? raw) {
    if (raw == null) return null;
    final cleaned = raw.trim();
    if (cleaned.isEmpty) return null;

    final m = RegExp(r'(-?\d+(?:\.\d+)?),\s*(-?\d+(?:\.\d+)?)')
        .firstMatch(cleaned);
    if (m == null) return null;

    final lat = double.tryParse(m.group(1)!);
    final lng = double.tryParse(m.group(2)!);
    if (lat == null || lng == null) return null;
    return (lat, lng);
  }

  /// Resolves a (possibly shortened) Google Maps URL and extracts (lat, lng).
  /// Works for both full URLs and short links like https://maps.app.goo.gl/xxx
  static Future<(double, double)?> resolveAndParseLatLng(String url) async {
    // Try direct parsing first (instant, no network)
    final direct = tryParseLatLngFromUrl(url);
    if (direct != null) return direct;

    // For shortened URLs follow redirects to get the full URL
    final isShortened = url.contains('goo.gl') ||
        url.contains('maps.app') ||
        url.contains('bit.ly') ||
        url.contains('tinyurl');

    if (!isShortened) return null;

    try {
      final client = HttpClient()
        ..connectionTimeout = const Duration(seconds: 10);

      String currentUrl = url;

      // Follow up to 8 redirects manually
      for (int i = 0; i < 8; i++) {
        final req = await client.getUrl(Uri.parse(currentUrl));
        req.followRedirects = false;
        req.headers.set('User-Agent',
            'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36');
        final resp = await req.close();
        await resp.drain(); // drain body

        if (resp.statusCode >= 300 && resp.statusCode < 400) {
          final location = resp.headers.value('location');
          if (location == null) break;
          currentUrl = location;

          // Try to parse coordinates from the expanded URL at each step
          final coords = tryParseLatLngFromUrl(currentUrl);
          if (coords != null) {
            client.close();
            return coords;
          }
        } else {
          break;
        }
      }

      client.close();
    } catch (_) {
      // best effort – ignore errors
    }

    return null;
  }
}