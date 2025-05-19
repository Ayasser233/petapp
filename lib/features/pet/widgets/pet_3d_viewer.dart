import 'dart:convert';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter/material.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:petapp/core/utils/app_colors.dart';

class Pet3DViewer extends StatefulWidget {
  final String petType;
  final String? modelPath;
  final bool allowRotation;
  final bool allowZoom;
  final double viewerHeight;
  final Color? backgroundColor;
  final Function(String)? onSymptomSelected;

  const Pet3DViewer({
    super.key,
    required this.petType,
    this.modelPath,
    this.allowRotation = true,
    this.allowZoom = true,
    this.viewerHeight = 500,
    this.backgroundColor,
    this.onSymptomSelected,
  });

  @override
  State<Pet3DViewer> createState() => _Pet3DViewerState();
}

class _Pet3DViewerState extends State<Pet3DViewer> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _isMenuOpen = false;
  late WebViewController _controller;
  late AnimationController _animController;
  
  final Map<String, List<String>> _bodyPartSymptoms = {
    'head': ['Ear infection', 'Eye irritation', 'Nasal discharge', 'Dental issues'],
    'chest': ['Coughing', 'Breathing difficulty', 'Chest pain', 'Heart issues'],
    'abdomen': ['Vomiting', 'Diarrhea', 'Bloating', 'Appetite loss'],
    'legs': ['Limping', 'Joint pain', 'Swelling', 'Mobility issues'],
    'tail': ['Irritation', 'Injury', 'Wagging issues', 'Pain when touched'],
  };

  @override
  void initState() {
    super.initState();
    
    // Set up menu animation
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Initialize controller here where it's safe to access context
    _initializeController();
  }
  
  void _initializeController() {
    final isDark = THelperFunctions.isDarkMode(context);
    
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'bodyPartSelected',
        onMessageReceived: (JavaScriptMessage message) {
          final part = message.message;
          _showSymptomSelectionDialog(context, part);
        },
      )
      ..addJavaScriptChannel(
        'modelLoaded',
        onMessageReceived: (_) {
          setState(() {
            _isLoading = false;
          });
        },
      )
      ..setBackgroundColor(widget.backgroundColor ?? 
          (isDark ? Colors.black : Colors.grey[100]!)
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            Future.delayed(const Duration(seconds: 2), () {
              if (_isLoading) {
                setState(() {
                  _isLoading = false;
                });
              }
            });
          },
        ),
      );
      
    _loadHtmlContent();
  }

  // Toggle side menu
  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
      if (_isMenuOpen) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    });
  }

  // Add this method to load and encode models
  Future<String> _getEncodedModelData(String assetPath) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      final List<int> bytes = data.buffer.asUint8List();
      final String base64Model = base64Encode(bytes);
      return base64Model;
    } catch (e) {
      debugPrint('Error loading model: $e');
      // Return a fallback online model if loading fails
      return '';
    }
  }
  
  // Replace the _getModelHtml method with this
  Future<String> _getModelHtml() async {
    final isDark = THelperFunctions.isDarkMode(context);
    final bgColor = widget.backgroundColor != null
        ? '#${widget.backgroundColor!.value.toRadixString(16).substring(2)}'
        : isDark
            ? '#000000'
            : '#f5f5f5';

    // Try to get model from assets
    final assetPath = widget.petType.toLowerCase() == 'dog'
        ? 'assets/models/dog_model.glb'
        : 'assets/models/cat_model.glb';
    
    // Try loading the asset model, but fallback to online models if needed
    String modelSrc;
    String base64Model = await _getEncodedModelData(assetPath);
    
    if (base64Model.isNotEmpty) {
      // Use data URI for local models
      modelSrc = 'data:model/gltf-binary;base64,$base64Model';
    } else {
      // Fallback to online models
      modelSrc = widget.petType.toLowerCase() == 'dog'
          ? 'https://modelviewer.dev/shared-assets/models/Astronaut.glb'
          : 'https://modelviewer.dev/shared-assets/models/RobotExpressive.glb';
    }

    return '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script type="module" src="https://ajax.googleapis.com/ajax/libs/model-viewer/3.1.1/model-viewer.min.js"></script>
        <style>
          body {
            margin: 0;
            padding: 0;
            width: 100vw;
            height: 100vh;
            background-color: $bgColor;
            overflow: hidden;
          }
          
          model-viewer {
            width: 100%;
            height: 100%;
            background-color: $bgColor;
            --poster-color: transparent;
          }
          
          /* Hide hotspots by default - we'll use the side menu instead */
          // .hotspot {
          //   display: none;
          // }
        </style>
      </head>
      <body>
        <model-viewer
          src="$modelSrc"
          alt="3D Model of ${widget.petType}"
          camera-controls="false"
          disable-zoom="true"
          auto-rotate="false"
          rotation-per-second="0deg"
          camera-orbit="0deg 75deg 2.5m"
          min-camera-orbit="auto auto auto"
          max-camera-orbit="auto auto auto"
          environment-image="neutral"
          exposure="1"
          shadow-intensity="0"
          id="petModel"
          >
          <!-- Hidden hotspots for reference, we'll access these via menu -->
          <button class="hotspot" slot="hotspot-head" data-position="0 1.5 0" data-normal="0 1 0.5">H</button>
          <button class="hotspot" slot="hotspot-chest" data-position="0 0.5 0.5" data-normal="0 0 1">C</button>
          <button class="hotspot" slot="hotspot-abdomen" data-position="0 0 0" data-normal="0 0 1">A</button>
          <button class="hotspot" slot="hotspot-legs" data-position="0.5 -1 0" data-normal="1 0 0">L</button>
          <button class="hotspot" slot="hotspot-tail" data-position="0 -0.5 -1" data-normal="0 0 -1">T</button>
        </model-viewer>
        
        <script>
          function selectBodyPart(part) {
            // Send message to Flutter
            window.bodyPartSelected.postMessage(part);
          }
          
          // Notify Flutter when the model is loaded
          document.querySelector('model-viewer').addEventListener('load', function() {
            window.modelLoaded.postMessage('loaded');
          });
        </script>
      </body>
      </html>
    ''';
  }

  // Update the _loadHtmlContent method to handle async
  Future<void> _loadHtmlContent() async {
    final html = await _getModelHtml();
    _controller.loadHtmlString(html);
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 3D Model Viewer with constrained height
          Container(
            height: widget.viewerHeight,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height , // Limit height to 60% of screen
            ),
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? 
                  (isDark ? Colors.black : Colors.grey[100]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  WebViewWidget(
                    controller: _controller,
                  ),
                  
                  // Loading indicator
                  if (_isLoading)
                    Container(
                      color: widget.backgroundColor ?? 
                          (isDark ? Colors.black : Colors.grey[100]),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(
                              color: AppColors.orange,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Loading ${widget.petType} model...',
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showSymptomSelectionDialog(BuildContext context, String bodyPart) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? Colors.grey[850] : Colors.white;
    final symptoms = _bodyPartSymptoms[bodyPart] ?? [];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgColor,
        title: Text(
          '${bodyPart[0].toUpperCase() + bodyPart.substring(1)} Symptoms',
          style: TextStyle(color: textColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: symptoms.map((symptom) {
            final String localBodyPart = bodyPart; // Capture bodyPart for the closure
            return ListTile(
              title: Text(
                symptom,
                style: TextStyle(color: textColor),
              ),
              onTap: () {
                if (widget.onSymptomSelected != null) {
                  widget.onSymptomSelected!('$localBodyPart: $symptom');
                }
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.orange),
            ),
          ),
        ],
      ),
    );
  }
}