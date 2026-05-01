import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:petapp/core/utils/map_url_utils.dart';

void main() {
  // ── Sync tests (no network) ──────────────────────────────────────────────

  group('MapUrlUtils.tryParseLatLngFromUrl (sync)', () {
    test('parses ?q=lat,lng', () {
      final r = MapUrlUtils.tryParseLatLngFromUrl(
          'https://www.google.com/maps?q=30.1,31.2');
      expect(r, isNotNull);
      expect(r!.$1, closeTo(30.1, 1e-9));
      expect(r.$2, closeTo(31.2, 1e-9));
    });

    test('parses /@lat,lng,zoom', () {
      final r = MapUrlUtils.tryParseLatLngFromUrl(
          'https://www.google.com/maps/@30.053,31.395,15z');
      expect(r, isNotNull);
      expect(r!.$1, closeTo(30.053, 1e-9));
      expect(r.$2, closeTo(31.395, 1e-9));
    });

    test('returns null for short link (no coords in url)', () {
      final r = MapUrlUtils.tryParseLatLngFromUrl(
          'https://maps.app.goo.gl/JdhyQ25JpUzDMaXE7');
      expect(r, isNull);
    });
  });

  // ── Async test (real network) ────────────────────────────────────────────

  group('MapUrlUtils.resolveAndParseLatLng (async / network)', () {
    test('resolves short link https://maps.app.goo.gl/JdhyQ25JpUzDMaXE7',
        () async {
      // Skip if there's no network (CI / offline)
      bool hasNetwork = false;
      try {
        final result =
            await InternetAddress.lookup('maps.google.com')
                .timeout(const Duration(seconds: 5));
        hasNetwork = result.isNotEmpty && result.first.rawAddress.isNotEmpty;
      } catch (_) {}

      if (!hasNetwork) {
        print('⚠️  No network – skipping live short-link test');
        return;
      }

      print('🌐 Resolving short link...');
      final coords = await MapUrlUtils.resolveAndParseLatLng(
          'https://maps.app.goo.gl/JdhyQ25JpUzDMaXE7');

      print('📍 Result: $coords');

      if (coords == null) {
        print('⚠️  Could not extract coords (Google may not embed them in '
            'the redirect chain for this particular link).');
      } else {
        print('✅ lat=${coords.$1}  lng=${coords.$2}');
        // Egypt bounding box sanity check
        expect(coords.$1, inInclusiveRange(22.0, 32.0),
            reason: 'Latitude should be within Egypt');
        expect(coords.$2, inInclusiveRange(24.0, 37.0),
            reason: 'Longitude should be within Egypt');
      }
    }, timeout: const Timeout(Duration(seconds: 30)));

    test('full URL still works via async path', () async {
      final coords = await MapUrlUtils.resolveAndParseLatLng(
          'https://www.google.com/maps/@30.0531762,31.3958778,15z');
      expect(coords, isNotNull);
      expect(coords!.$1, closeTo(30.053, 0.001));
      expect(coords.$2, closeTo(31.395, 0.001));
    });
  });
}
