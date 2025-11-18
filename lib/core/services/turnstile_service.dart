import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:petapp/core/config/turnstile_config.dart';
import 'package:petapp/core/utils/api_constants.dart';

/// Service to generate Cloudflare Turnstile tokens
/// This service creates an invisible WebView to load Turnstile and retrieve the token
class TurnstileService {
  static const String _turnstileSiteKey = TurnstileConfig.siteKey;

  /// Generates a Turnstile token
  /// Returns null if token generation fails
  static Future<String?> generateToken(BuildContext context) async {
    try {
      // If we're pointing to the dev API, use a fixed dev token expected by the backend
      // This avoids requiring a real Cloudflare Turnstile verification during development
      if (ApiConstants.apiBaseUrl.contains('dev')) {
        debugPrint('Using dev Turnstile token override');
        return 'cf-turnstile-token';
      }
      final token = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const _TurnstileWebView(siteKey: _turnstileSiteKey),
          fullscreenDialog: true,
        ),
      );
      return token;
    } catch (e) {
      debugPrint('Error generating Turnstile token: $e');
      return null;
    }
  }

  /// Generates a Turnstile token without navigation (background mode)
  /// Use this for background token generation
  static Future<String?> generateTokenSilent() async {
    // If we're pointing to the dev API, return the fixed dev token
    if (ApiConstants.apiBaseUrl.contains('dev')) {
      debugPrint('Using dev Turnstile token override (silent)');
      return 'cf-turnstile-token';
    }

    // This is a simplified placeholder. In production, implement silent token
    // generation (e.g. hidden WebView or platform channel) if needed.
    debugPrint('Silent token generation not implemented for production');
    return null;
  }
}

/// Internal WebView widget to handle Turnstile token generation
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
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..addJavaScriptChannel(
        'TurnstileChannel',
        onMessageReceived: (JavaScriptMessage message) {
          final response = message.message;

          // Check if it's an error message
          if (response.startsWith('ERROR:')) {
            debugPrint('Turnstile error: $response');
            // Use a post-frame callback and re-check mounted to avoid race where
            // the State becomes unmounted between the JS callback and Navigator usage.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              try {
                Navigator.of(context).pop(null);
              } catch (e) {
                debugPrint('Navigator pop failed after JS error: $e');
              }
            });
            return;
          }

          // Valid token received
          debugPrint(
              'Turnstile token received: ${response.length > 20 ? "${response.substring(0, 20)}..." : response}');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            try {
              Navigator.of(context).pop(response);
            } catch (e) {
              debugPrint('Navigator pop failed after receiving token: $e');
            }
          });
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
                if (!mounted) return;
                setState(() {
                  _isLoading = false;
                });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
          },
        ),
      )
      ..enableZoom(false);

    _loadTurnstileHTML();
  }

  Future<void> _loadTurnstileHTML() async {
    final html = '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Turnstile Verification</title>
        <script src="https://challenges.cloudflare.com/turnstile/v0/api.js?onload=onloadTurnstileCallback" async defer></script>
        <style>
            body {
                margin: 0;
                padding: 20px;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                background-color: #f5f5f5;
            }
            .container {
                text-align: center;
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                max-width: 400px;
                width: 100%;
            }
            h2 {
                color: #333;
                margin-bottom: 10px;
            }
            .subtitle {
                color: #666;
                font-size: 14px;
                margin-bottom: 20px;
            }
            .turnstile-container {
                display: flex;
                justify-content: center;
                margin: 20px 0;
                min-height: 65px;
            }
            .loading {
                color: #666;
                margin-top: 10px;
                font-size: 14px;
            }
            .error {
                color: #d32f2f;
                margin-top: 10px;
                font-size: 14px;
                padding: 10px;
                background: #ffebee;
                border-radius: 5px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Security Verification</h2>
            <p class="subtitle">Verifying you are human</p>
            <div class="turnstile-container" id="turnstile-widget"></div>
            <p class="loading" id="status">Loading verification...</p>
        </div>

        <script>
            let widgetId = null;
            
            window.onloadTurnstileCallback = function () {
                try {
                    document.getElementById('status').textContent = 'Initializing...';
                    
                    widgetId = turnstile.render('#turnstile-widget', {
                        sitekey: '${widget.siteKey}',
                        callback: function(token) {
                            console.log('Token received successfully');
                            document.getElementById('status').textContent = 'Verification complete!';
                            
                            // Send token back to Flutter
                            if (window.TurnstileChannel) {
                                window.TurnstileChannel.postMessage(token);
                            } else {
                                console.error('TurnstileChannel not available');
                            }
                        },
                        'error-callback': function(error) {
                            console.error('Turnstile error:', error);
                            let errorMessage = 'Verification failed. ';
                            
                            // Error code explanations
                            if (error.includes('110200')) {
                                errorMessage = 'Domain not authorized. Please configure Turnstile for mobile app usage.';
                            } else if (error.includes('110100')) {
                                errorMessage = 'Invalid site key. Please check configuration.';
                            } else {
                                errorMessage += 'Error: ' + error;
                            }
                            
                            document.getElementById('status').innerHTML = 
                                '<div class="error">' + errorMessage + '</div>';
                            
                            // Return null to Flutter after 3 seconds
                            setTimeout(function() {
                                if (window.TurnstileChannel) {
                                    window.TurnstileChannel.postMessage('ERROR:' + error);
                                }
                            }, 3000);
                        },
                        'timeout-callback': function() {
                            console.log('Turnstile timeout');
                            document.getElementById('status').innerHTML = 
                                '<div class="error">Verification timeout. Please try again.</div>';
                            
                            setTimeout(function() {
                                if (window.TurnstileChannel) {
                                    window.TurnstileChannel.postMessage('ERROR:TIMEOUT');
                                }
                            }, 2000);
                        },
                        theme: 'light',
                        size: 'normal'
                    });
                    
                    console.log('Turnstile widget initialized with ID:', widgetId);
                } catch (e) {
                    console.error('Error initializing Turnstile:', e);
                    document.getElementById('status').innerHTML = 
                        '<div class="error">Failed to initialize: ' + e.message + '</div>';
                }
            };
            
            // Fallback if script doesn't load
            setTimeout(function() {
                if (typeof turnstile === 'undefined') {
                    document.getElementById('status').innerHTML = 
                        '<div class="error">Failed to load verification service. Please check your internet connection.</div>';
                }
            }, 10000);
        </script>
    </body>
    </html>
    ''';

    await _controller.loadHtmlString(html);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Verification'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
