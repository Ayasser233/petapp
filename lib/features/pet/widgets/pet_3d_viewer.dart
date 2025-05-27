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
  final Function(String) onSymptomSelected;
  final Function(String)? onBodyPartSelected; // Add this callback

  const Pet3DViewer({
    super.key,
    required this.petType,
    this.modelPath,
    this.allowRotation = true,
    this.allowZoom = true,
    this.viewerHeight = 300,
    this.backgroundColor,
    required this.onSymptomSelected,
    this.onBodyPartSelected, // Add this parameter
  });

  @override
  State<Pet3DViewer> createState() => _Pet3DViewerState();
}

class _Pet3DViewerState extends State<Pet3DViewer> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  late WebViewController _controller;
  late AnimationController _animController;
  
  final Map<String, List<String>> _bodyPartSymptoms = {
    'head': ['Ear infection', 'Eye irritation', 'Nasal discharge', 'Dental issues'],
    'chest': ['Coughing', 'Breathing difficulty', 'Chest pain', 'Heart issues'],
    'abdomen': ['Vomiting', 'Diarrhea', 'Bloating', 'Appetite loss'],
    'legs': ['Limping', 'Joint pain', 'Swelling', 'Mobility issues'],
    'tail': ['Irritation', 'Injury', 'Wagging issues', 'Pain when touched'],
  };

  // Define a map for clickable regions of the model
  final Map<String, List<Vector3>> _bodyPartRegions = {
    'head': [Vector3(-10, 20, 0), Vector3(10, 40, 20)], // Example bounding box for head
    'chest': [Vector3(-15, 0, -10), Vector3(15, 20, 10)], // Example for chest
    'abdomen': [Vector3(-15, -10, -10), Vector3(15, 0, 10)], // Example for abdomen
    'legs': [Vector3(-15, -40, -10), Vector3(15, -10, 10)], // Example for legs
    'tail': [Vector3(-5, -40, -30), Vector3(5, -30, -10)], // Example for tail
  };

  String? _highlightedPart;

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
        'modelClicked',
        onMessageReceived: (JavaScriptMessage message) {
          try {
            final coords = jsonDecode(message.message);
            final x = (coords['x'] as double) * MediaQuery.of(context).size.width;
            final y = (coords['y'] as double) * widget.viewerHeight;
            
            // Use _handleModelTap with these coordinates
            _handleModelClickFromWebView(Offset(x, y));
          } catch (e) {
            debugPrint('Error handling model click: $e');
          }
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
          
          .hotspot {
            display: block;
            width: 20px;
            height: 20px;
            border-radius: 10px;
            border: none;
            background-color: orange;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.25);
            position: relative;
            transition: all 0.3s ease-in-out;
          }
          
          .hotspot:hover {
            transform: scale(1.2);
            background-color: #ff7700;
          }
          
          .annotation {
            background-color: #ffffff;
            position: absolute;
            transform: translate(10px, 10px);
            border-radius: 10px;
            padding: 10px;
            font-weight: bold;
          }
        </style>
      </head>
      <body>
        <model-viewer
          src="$modelSrc"
          alt="3D Model of ${widget.petType}"
          camera-controls="${widget.allowRotation ? 'true' : 'false'}"
          disable-zoom="${!widget.allowZoom ? 'true' : 'false'}"
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
          <!-- Visible hotspots for body parts -->
          <button class="hotspot" slot="hotspot-head" data-position="0 1.5 0" data-normal="0 1 0.5" data-part="head">
            <div class="annotation">Head</div>
          </button>
          <button class="hotspot" slot="hotspot-chest" data-position="0 0.5 0.5" data-normal="0 0 1" data-part="chest">
            <div class="annotation">Chest</div>
          </button>
          <button class="hotspot" slot="hotspot-abdomen" data-position="0 0 0" data-normal="0 0 1" data-part="abdomen">
            <div class="annotation">Abdomen</div>
          </button>
          <button class="hotspot" slot="hotspot-legs" data-position="0.5 -1 0" data-normal="1 0 0" data-part="legs">
            <div class="annotation">Legs</div>
          </button>
          <button class="hotspot" slot="hotspot-tail" data-position="0 -0.5 -1" data-normal="0 0 -1" data-part="tail">
            <div class="annotation">Tail</div>
          </button>
        </model-viewer>
        
        <script>
          const modelViewer = document.querySelector('model-viewer');
          const hotspots = document.querySelectorAll('.hotspot');
          
          // Hide annotations by default
          document.querySelectorAll('.annotation').forEach(annotation => {
            annotation.style.opacity = '0';
            annotation.style.display = 'none';
          });
          
          // Show annotation on hover
          hotspots.forEach(hotspot => {
            const annotation = hotspot.querySelector('.annotation');
            
            hotspot.addEventListener('mouseover', () => {
              annotation.style.display = 'block';
              setTimeout(() => {
                annotation.style.opacity = '1';
              }, 50);
            });
            
            hotspot.addEventListener('mouseout', () => {
              annotation.style.opacity = '0';
              setTimeout(() => {
                annotation.style.display = 'none';
              }, 300);
            });
            
            // When clicking a hotspot, send the body part to Flutter
            hotspot.addEventListener('click', () => {
              const part = hotspot.getAttribute('data-part');
              window.bodyPartSelected.postMessage(part);
            });
          });
          
          // Allow click anywhere on the model
          modelViewer.addEventListener('click', (event) => {
            const rect = modelViewer.getBoundingClientRect();
            const x = event.clientX - rect.left;
            const y = event.clientY - rect.top;
            const normalizedX = x / rect.width;
            const normalizedY = y / rect.height;
            
            // Send coordinates to Flutter for ray-casting
            window.modelClicked.postMessage(JSON.stringify({
              x: normalizedX,
              y: normalizedY
            }));
          });
          
          // Notify Flutter when the model is loaded
          modelViewer.addEventListener('load', function() {
            window.modelLoaded.postMessage('loaded');
            
            // Position the hotspots based on model size
            positionHotspots();
          });
          
          // Function to position hotspots based on model size
          function positionHotspots() {
            // This would need more sophisticated positioning based on actual model
            // Just a placeholder to demonstrate
          }
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
                widget.onSymptomSelected('$localBodyPart: $symptom');
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

  // Add this method to handle taps on the model
  void _handleModelTap(TapUpDetails details) {
    // Convert screen coordinates to model coordinates
    final RenderBox box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(details.globalPosition);
    
    // Calculate ray from camera through tap point
    final ray = _calculateRayFromCamera(localPosition);
    
    // Check which body part was hit
    String? hitPart = _findIntersectedBodyPart(ray);
    
    if (hitPart != null && widget.onBodyPartSelected != null) {
      widget.onBodyPartSelected!(hitPart);
    }
  }
  
  // Update these methods with simple implementations for testing:

  String? _findIntersectedBodyPart(Ray ray) {
    // Simplified implementation - divide screen into regions for testing
    final screenHeight = widget.viewerHeight;
    final position = ray.origin;
    
    // Simple division of the screen into body parts for testing
    if (position.y < screenHeight * 0.2) {
      return 'head';
    } else if (position.y < screenHeight * 0.4) {
      return 'chest';
    } else if (position.y < screenHeight * 0.6) {
      return 'abdomen';
    } else if (position.y < screenHeight * 0.8) {
      return 'legs';
    } else {
      return 'tail';
    }
  }
  
  // Placeholder for ray calculation
  Ray _calculateRayFromCamera(Offset position) {
    // Simplified ray calculation for testing
    return Ray(
      Vector3(position.dx, position.dy, 0),
      Vector3(0, 0, -1)
    );
  }

  // Add this method to your _Pet3DViewerState class

  void _handleModelClickFromWebView(Offset position) {
    // Calculate ray from camera through tap point
    final ray = _calculateRayFromCamera(position);
    
    // Check which body part was hit
    String? hitPart = _findIntersectedBodyPart(ray);
    
    if (hitPart != null) {
      // Show symptom dialog directly
      _showSymptomSelectionDialog(context, hitPart);
      
      // Also notify parent if needed
      if (widget.onBodyPartSelected != null) {
        widget.onBodyPartSelected!(hitPart);
      }
    }
  }
}

// You may need to define these classes if not already imported
class Vector3 {
  final double x, y, z;
  Vector3(this.x, this.y, this.z);
}

class Ray {
  final Vector3 origin;
  final Vector3 direction;
  Ray(this.origin, this.direction);
}