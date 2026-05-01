import 'package:dio/dio.dart';

/// Expands short map urls (e.g. https://maps.app.goo.gl/...) by following redirects.
///
/// This uses a HEAD first, then GET as a fallback, and returns the final resolved url.
class MapUrlExpanderService {
  final Dio _dio;

  MapUrlExpanderService(this._dio);

  Future<String?> expand(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    // If it's already a non-short google maps url, return as-is.
    if (!_looksLikeShortGoogleMapsUrl(uri)) {
      return url;
    }

    // Follow redirects. Dio will populate Response.redirects and realUri.
    try {
      final res = await _dio.headUri(
        uri,
        options: Options(
          followRedirects: true,
          maxRedirects: 8,
          validateStatus: (code) => code != null && code >= 200 && code < 400,
          responseType: ResponseType.plain,
        ),
      );
      return _extractFinalUrl(res) ?? res.realUri.toString();
    } catch (_) {
      // Some endpoints don't support HEAD, retry with GET.
      try {
        final res = await _dio.getUri(
          uri,
          options: Options(
            followRedirects: true,
            maxRedirects: 8,
            validateStatus: (code) => code != null && code >= 200 && code < 400,
            responseType: ResponseType.plain,
          ),
        );
        return _extractFinalUrl(res) ?? res.realUri.toString();
      } catch (_) {
        return null;
      }
    }
  }

  bool _looksLikeShortGoogleMapsUrl(Uri uri) {
    final host = uri.host.toLowerCase();
    return host == 'maps.app.goo.gl' || host.endsWith('.app.goo.gl');
  }

  String? _extractFinalUrl(Response res) {
    if (res.redirects.isEmpty) return null;
    return res.redirects.last.location.toString();
  }
}
