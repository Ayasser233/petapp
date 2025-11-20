import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:petapp/core/config/turnstile_config.dart';
import 'package:petapp/core/utils/api_constants.dart';

class TurnstileService {
  static const String _siteKey = TurnstileConfig.siteKey;

  /// Generates a Turnstile token
  /// Returns null if token generation fails
  static Future<String?> generateToken(BuildContext context) async {
    try {
      // --- DEV MODE: Return fixed token ---
      if (ApiConstants.apiBaseUrl.contains('dev')) {
        debugPrint('Using dev Turnstile token override');
        return 'cf-turnstile-token';
      }

      // --- PROD MODE: Show WebView for Turnstile ---
      final token = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (_) => const _TurnstileWebView(siteKey: _siteKey),
          fullscreenDialog: true,
        ),
      );
      return token;
    } catch (e) {
      debugPrint('Error generating Turnstile token: $e');
      return null;
    }
  }
}

class _TurnstileWebView extends StatefulWidget {
  final String siteKey;
  const _TurnstileWebView({required this.siteKey});

  @override
  State<_TurnstileWebView> createState() => _TurnstileWebViewState();
}

class _TurnstileWebViewState extends State<_TurnstileWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'TurnstileChannel',
        onMessageReceived: (msg) {
          final response = msg.message;
          if (response.startsWith('ERROR:')) {
            debugPrint('Turnstile error: $response');
            if (!mounted) return;
            Navigator.of(context).pop(null);
            return;
          }
          if (!mounted) return;
          Navigator.of(context).pop(response);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() => _isLoading = false);
          },
          onWebResourceError: (err) =>
              debugPrint('WebView error: ${err.description}'),
        ),
      )
      ..enableZoom(false);

    _loadTurnstileHTML();
  }

  Future<void> _loadTurnstileHTML() async {
    // Minimal HTML to host Turnstile widget
    final html = '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <script src="https://challenges.cloudflare.com/turnstile/v0/api.js?onload=onloadTurnstileCallback" async defer></script>
      <style>
        body { display:flex; justify-content:center; align-items:center; height:100vh; margin:0; }
      </style>
    </head>
    <body>
      <div id="turnstile-widget"></div>
      <script>
        window.onloadTurnstileCallback = function() {
          turnstile.render('#turnstile-widget', {
            sitekey: '${widget.siteKey}',
            callback: function(token) {
              window.TurnstileChannel.postMessage(token);
            },
            'error-callback': function(err) {
              window.TurnstileChannel.postMessage('ERROR:' + err);
            },
            theme: 'light',
            size: 'normal'
          });
        };
      </script>
    </body>
    </html>
    ''';

    await _controller.loadHtmlString(html);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security Verification')),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
