import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/utils/app_colors.dart';

/// Maps 3D model mesh names to body part categories
class MeshBodyPartMapper {
  /// Maps a mesh name to a body part category
  /// Returns the mapped body part key used in PetSymptomData
  static String mapMeshToBodyPart(String meshName) {
    final lowercase = meshName.toLowerCase();

    // Head-related meshes
    if (lowercase.contains('head') ||
        lowercase.contains('skull') ||
        lowercase.contains('eye') ||
        lowercase.contains('ear') ||
        lowercase.contains('mouth') ||
        lowercase.contains('jaw') ||
        lowercase.contains('nose') ||
        lowercase.contains('face') ||
        lowercase.contains('cranium')) {
      return 'head';
    }

    // Leg-related meshes
    if (lowercase.contains('leg') ||
        lowercase.contains('paw') ||
        lowercase.contains('foot') ||
        lowercase.contains('ankle') ||
        lowercase.contains('knee') ||
        lowercase.contains('limb') ||
        lowercase.contains('foreleg') ||
        lowercase.contains('hindleg') ||
        lowercase.contains('front') && lowercase.contains('leg') ||
        lowercase.contains('back') && lowercase.contains('leg')) {
      return 'legs';
    }

    // Buttocks/Anus-related meshes
    if (lowercase.contains('tail') ||
        lowercase.contains('butt') ||
        lowercase.contains('anus') ||
        lowercase.contains('rear') ||
        lowercase.contains('rump')) {
      return 'buttocks';
    }

    // Pelvis/Genital-related meshes
    if (lowercase.contains('pelvis') ||
        lowercase.contains('hip') ||
        lowercase.contains('genital') ||
        lowercase.contains('groin') ||
        lowercase.contains('abdomen') ||
        lowercase.contains('belly') ||
        lowercase.contains('stomach')) {
      return 'pelvis';
    }

    // Skin/Coat - body/torso
    if (lowercase.contains('body') ||
        lowercase.contains('torso') ||
        lowercase.contains('chest') ||
        lowercase.contains('back') ||
        lowercase.contains('spine') ||
        lowercase.contains('rib') ||
        lowercase.contains('skin') ||
        lowercase.contains('fur') ||
        lowercase.contains('coat')) {
      return 'skin';
    }

    // Default to skin for unmatched meshes (general body)
    return 'skin';
  }

  /// Gets a user-friendly body part name for display
  static String getBodyPartDisplayName(String bodyPartKey) {
    switch (bodyPartKey) {
      case 'head':
        return 'Head';
      case 'legs':
        return 'Legs';
      case 'skin':
        return 'Skin & Coat';
      case 'pelvis':
        return 'Pelvis';
      case 'buttocks':
        return 'Buttocks';
      default:
        return 'Unknown';
    }
  }
}

class Pet3DViewerWebView extends StatefulWidget {
  final String petType;
  final String? modelPath;
  final bool allowRotation;
  final bool allowZoom;
  final double viewerHeight;
  final Color? backgroundColor;
  final Function(String meshName)? onMeshClicked;
  final Function(List<String> meshNames)? onMeshesDetected;

  const Pet3DViewerWebView({
    super.key,
    required this.petType,
    this.modelPath,
    this.allowRotation = true,
    this.allowZoom = true,
    this.viewerHeight = 500,
    this.backgroundColor,
    this.onMeshClicked,
    this.onMeshesDetected,
  });

  @override
  State<Pet3DViewerWebView> createState() => _Pet3DViewerWebViewState();
}

class _Pet3DViewerWebViewState extends State<Pet3DViewerWebView> {
  late WebViewController _controller;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() async {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: _handleJavaScriptMessage,
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            await _loadHTMLAndModel();
          },
        ),
      );

    // Load the HTML file
    final htmlContent =
        await rootBundle.loadString('assets/models/viewer.html');
    await _controller.loadHtmlString(htmlContent);
  }

  Future<void> _loadHTMLAndModel() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Determine model path
      String modelPath = widget.modelPath ??
          (widget.petType.toLowerCase() == 'dog'
              ? 'assets/models/dogModel.obj'
              : 'assets/models/catModel.obj');

      // Determine file type from extension
      final fileExtension = modelPath.split('.').last.toLowerCase();
      final isOBJ = fileExtension == 'obj';

      // Load model file as bytes
      final ByteData data = await rootBundle.load(modelPath);
      final List<int> bytes = data.buffer.asUint8List();

      // Convert to base64 data URL
      final String base64Data = base64Encode(bytes);
      final String mimeType = isOBJ ? 'text/plain' : 'model/gltf-binary';
      final String dataUrl = 'data:$mimeType;base64,$base64Data';

      // Check if widget is still mounted before using context
      if (!mounted) return;

      // Get background color
      final isDark = THelperFunctions.isDarkMode(context);
      final bgColor =
          widget.backgroundColor ?? (isDark ? Colors.black : Colors.grey[100]);
      final colorHex =
          '#${bgColor!.toARGB32().toRadixString(16).substring(2, 8)}';

      // Initialize scene
      await _controller.runJavaScript('''
        handleFlutterMessage({
          action: 'init',
          backgroundColor: '$colorHex'
        });
      ''');

      // Small delay to ensure scene is ready
      await Future.delayed(const Duration(milliseconds: 500));

      // Load model
      await _controller.runJavaScript('''
        handleFlutterMessage({
          action: 'loadModel',
          dataUrl: '$dataUrl',
          fileType: '$fileExtension'
        });
      ''');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Error loading model: $e';
        _isLoading = false;
      });
      debugPrint('Error loading model: $e');
    }
  }

  void _handleJavaScriptMessage(JavaScriptMessage message) {
    try {
      final data = jsonDecode(message.message);
      final type = data['type'];
      final payload = data['data'];

      switch (type) {
        case 'modelLoaded':
          setState(() {
            _isLoading = false;
            if (payload['success'] == false) {
              _errorMessage = payload['error'] ?? 'Unknown error';
            }
          });
          break;

        case 'meshesDetected':
          final meshes = List<String>.from(payload['meshes'] ?? []);
          setState(() {});
          if (widget.onMeshesDetected != null) {
            widget.onMeshesDetected!(meshes);
          }
          debugPrint('Detected meshes: $meshes');
          break;

        case 'meshClicked':
          final meshName = payload['name'] as String;
          // Map the mesh name to a body part category
          final bodyPart = MeshBodyPartMapper.mapMeshToBodyPart(meshName);
          debugPrint(
              'Mesh clicked: $meshName → Mapped to body part: $bodyPart');

          if (widget.onMeshClicked != null) {
            // Pass the mapped body part instead of mesh name
            widget.onMeshClicked!(bodyPart);
          }
          break;

        case 'meshNames':
          final names = List<String>.from(payload['names'] ?? []);
          debugPrint('Available mesh names: $names');
          break;
      }
    } catch (e) {
      debugPrint('Error handling JavaScript message: $e');
    }
  }

  void highlightMesh(String meshName) {
    _controller.runJavaScript('''
      handleFlutterMessage({
        action: 'highlightMesh',
        meshName: '$meshName'
      });
    ''');
  }

  void clearHighlights() {
    _controller.runJavaScript('''
      handleFlutterMessage({
        action: 'clearHighlights'
      });
    ''');
  }

  void rotateModel({double angle = 90}) {
    _controller.runJavaScript('''
      handleFlutterMessage({
        action: 'rotateModel',
        angle: $angle
      });
    ''');
  }

  void getMeshNames() {
    _controller.runJavaScript('''
      handleFlutterMessage({
        action: 'getMeshNames'
      });
    ''');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.viewerHeight,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // WebView
            WebViewWidget(controller: _controller),

            // Loading indicator
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: AppColors.orange,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Loading 3D Model...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),

            // Error message
            if (_errorMessage != null)
              Container(
                color: Colors.black87,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _errorMessage = null;
                            });
                            _loadHTMLAndModel();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Rotation button
            if (widget.allowRotation && !_isLoading && _errorMessage == null)
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  mini: true,
                  onPressed: () => rotateModel(),
                  backgroundColor: AppColors.orange,
                  child: const Icon(
                    Icons.rotate_right,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
