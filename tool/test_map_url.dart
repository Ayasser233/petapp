/// Standalone script to test MapUrlUtils coordinate resolution.
/// Run with:  dart run tool/test_map_url.dart
library;

import 'dart:io';

// ─── inline copy of MapUrlUtils (no Flutter dependency needed) ───────────────

(double, double)? tryParseLatLngFromUrl(String url) {
  try {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    for (final key in const ['q', 'query', 'll']) {
      final raw = uri.queryParameters[key];
      final coords = _tryParseLatLngPair(raw);
      if (coords != null) return coords;
    }

    final matchAt =
        RegExp(r'@(-?\d+(?:\.\d+)?),(-?\d+(?:\.\d+)?)').firstMatch(url);
    if (matchAt != null) {
      final a = double.tryParse(matchAt.group(1)!);
      final b = double.tryParse(matchAt.group(2)!);
      if (a != null && b != null) return (a, b);
    }

    final matchAny =
        RegExp(r'(-?\d+(?:\.\d+)?),\s*(-?\d+(?:\.\d+)?)').firstMatch(url);
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

(double, double)? _tryParseLatLngPair(String? raw) {
  if (raw == null) return null;
  final cleaned = raw.trim();
  if (cleaned.isEmpty) return null;
  final m =
      RegExp(r'(-?\d+(?:\.\d+)?),\s*(-?\d+(?:\.\d+)?)').firstMatch(cleaned);
  if (m == null) return null;
  final lat = double.tryParse(m.group(1)!);
  final lng = double.tryParse(m.group(2)!);
  if (lat == null || lng == null) return null;
  return (lat, lng);
}

Future<(double, double)?> resolveAndParseLatLng(String url) async {
  final direct = tryParseLatLngFromUrl(url);
  if (direct != null) return direct;

  final isShortened = url.contains('goo.gl') || url.contains('maps.app');
  if (!isShortened) return null;

  try {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10);

    String currentUrl = url;

    for (int i = 0; i < 8; i++) {
      print('  ↪  hop $i  $currentUrl');
      final req = await client.getUrl(Uri.parse(currentUrl));
      req.followRedirects = false;
      req.headers.set(
          'User-Agent', 'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36');
      final resp = await req.close();
      await resp.drain();

      if (resp.statusCode >= 300 && resp.statusCode < 400) {
        final location = resp.headers.value('location');
        if (location == null) break;
        currentUrl = location;

        final coords = tryParseLatLngFromUrl(currentUrl);
        if (coords != null) {
          client.close();
          return coords;
        }
      } else {
        print('  status ${resp.statusCode} – stopping redirect chain');
        break;
      }
    }

    client.close();
  } catch (e) {
    print('  ⚠️  HTTP error: $e');
  }

  return null;
}

// ─── tests ───────────────────────────────────────────────────────────────────

void _check(String label, bool condition) {
  if (condition) {
    print('  ✅  $label');
  } else {
    print('  ❌  FAIL: $label');
    exitCode = 1;
  }
}

Future<void> main() async {
  print('\n══════════════════════════════════════════');
  print(' MapUrl coordinate resolution tests');
  print('══════════════════════════════════════════\n');

  // ── sync tests ────────────────────────────────────────────────────────────
  print('── Sync (no network) ─────────────────────');

  var r = tryParseLatLngFromUrl('https://www.google.com/maps?q=30.1,31.2');
  _check('?q=30.1,31.2  →  lat≈30.1 lng≈31.2',
      r != null && (r.$1 - 30.1).abs() < 1e-6 && (r.$2 - 31.2).abs() < 1e-6);

  r = tryParseLatLngFromUrl(
      'https://www.google.com/maps/@30.0531762,31.3958778,15z');
  _check('/@lat,lng,zoom  →  lat≈30.053',
      r != null && (r.$1 - 30.0531762).abs() < 1e-4);

  r = tryParseLatLngFromUrl(
      'https://www.google.com/maps/search/?api=1&query=30.123,31.456');
  _check('?query=lat,lng  →  lat≈30.123',
      r != null && (r.$1 - 30.123).abs() < 1e-6);

  r = tryParseLatLngFromUrl('https://maps.app.goo.gl/JdhyQ25JpUzDMaXE7');
  _check('short link sync  →  null (expected)', r == null);

  // ── async test ────────────────────────────────────────────────────────────
  print('\n── Async (follows redirect chain) ────────');
  print('Resolving https://maps.app.goo.gl/JdhyQ25JpUzDMaXE7 …');

  final coords =
      await resolveAndParseLatLng('https://maps.app.goo.gl/JdhyQ25JpUzDMaXE7');

  if (coords == null) {
    print('  ⚠️  Result: null');
    print('      Google did not embed coordinates in the redirect chain.');
    print('      This is expected for some short links; the vet\'s coordinates');
    print('      should come from the API response (location.coordinates).');
  } else {
    print('  📍 lat=${coords.$1}  lng=${coords.$2}');
    _check(
        'lat in Egypt range (22–32)',
        coords.$1 >= 22.0 && coords.$1 <= 32.0,
    );
    _check(
        'lng in Egypt range (24–37)',
        coords.$2 >= 24.0 && coords.$2 <= 37.0,
    );
  }

  print('\n── Full URL via async path ────────────────');
  final coords2 = await resolveAndParseLatLng(
      'https://www.google.com/maps/@30.0531762,31.3958778,15z');
  _check('full URL async  →  lat≈30.053',
      coords2 != null && (coords2.$1 - 30.0531762).abs() < 1e-4);

  print('\n══════════════════════════════════════════');
  print(exitCode == 0 ? ' All tests passed 🎉' : ' Some tests FAILED ❌');
  print('══════════════════════════════════════════\n');
}
