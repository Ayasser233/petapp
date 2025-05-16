import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:petapp/core/utils/app_colors.dart';

class Pet3DModelViewer extends StatefulWidget {
  final String petType;
  final Function(String) onBodyPartSelected;
  final bool isDark;

  const Pet3DModelViewer({
    super.key,
    required this.petType,
    required this.onBodyPartSelected,
    required this.isDark,
  });

  @override
  State<Pet3DModelViewer> createState() => _Pet3DModelViewerState();
}

class _Pet3DModelViewerState extends State<Pet3DModelViewer> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _modelError = false;
  double _rotationValue = 0.0;
  double _zoomLevel = 1.0;
  
  late AnimationController _autoRotateController;
  bool _isAutoRotating = false;

  @override
  void initState() {
    super.initState();
    
    // Setup auto-rotation controller
    _autoRotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..addListener(() {
      if (mounted && _isAutoRotating) {
        setState(() {
          _rotationValue = _autoRotateController.value * 360;
        });
      }
    });
    
    // Short delay to prepare loading
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _autoRotateController.dispose();
    super.dispose();
  }

  void _toggleAutoRotate() {
    setState(() {
      _isAutoRotating = !_isAutoRotating;
      if (_isAutoRotating) {
        _autoRotateController.repeat();
      } else {
        _autoRotateController.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    
    // Use simplified model paths
    final String modelPath = widget.petType == 'dog' 
        ? 'assets/models/dog_model.obj'  
        : 'assets/models/cat_model.obj';

    return Stack(
      children: [
        // Loading indicator
        if (_isLoading)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: AppColors.orange,
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading 3D model...',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          
        // Error fallback
        if (_modelError && !_isLoading)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.orange,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Could not load 3D model',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                      _modelError = false;
                      Future.delayed(const Duration(seconds: 1), () {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      });
                    });
                  },
                  child: const Text(
                    'Try Again',
                    style: TextStyle(
                      color: AppColors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
        // 3D Model Viewer with custom handling
        if (!_isLoading && !_modelError)
          GestureDetector(
            onScaleUpdate: (details) {
              if (details.scale != 1.0) {
                setState(() {
                  // Handle zoom
                  _zoomLevel = (_zoomLevel * details.scale).clamp(0.5, 2.0);
                });
              } else if (details.pointerCount == 1) {
                // Handle manual rotation
                setState(() {
                  _rotationValue = (_rotationValue + details.focalPointDelta.dx * 0.5) % 360;
                });
              }
            },
            child: Container(
              color: Colors.transparent,
              child: Cube(
                onSceneCreated: (Scene scene) {
                  try {
                    scene.world.add(Object(
                      fileName: modelPath,
                      scale: Vector3(_zoomLevel * 5.0, _zoomLevel * 5.0, _zoomLevel * 5.0),
                      position: Vector3(0, -5.0, 0),
                      rotation: Vector3(0, _getRadians(_rotationValue), 0),
                      backfaceCulling: false,
                      // Error handling is managed in the try-catch block
                    ));
                    
                    // Configure the scene
                    scene.camera.zoom = 10;
                    scene.camera.position.setFrom(Vector3(0, 0, 10));
                    scene.light.position.setFrom(Vector3(10, 10, 10));
                    scene.light.setColor(Colors.white, 0.8, 0.8,1);
                    
                    scene.update();
                    
                    // Timer to check if model loaded successfully
                    Future.delayed(const Duration(seconds: 3), () {
                      if (mounted && scene.world.children.isNotEmpty) {
                        final firstObject = scene.world.children[0];
                        if (firstObject.mesh == null || firstObject.mesh?.vertices == null || firstObject.mesh!.vertices.isEmpty) {
                          setState(() {
                            _modelError = true;
                          });
                        }
                      }
                    });
                  } catch (e) {
                    if (mounted) {
                      setState(() {
                        _modelError = true;
                      });
                    }
                    print('Error loading 3D model: $e');
                  }
                },
                interactive: false, // We're handling gestures manually
              ),
            ),
          ),
        
        // Interactive hotspot overlays for body parts
        if (!_isLoading && !_modelError) ...[
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: _buildHotspot('Head'),
          ),
          Positioned(
            top: 160,
            left: 0,
            right: 0,
            child: _buildHotspot('Neck & Chest'),
          ),
          Positioned(
            top: 220,
            left: 0,
            right: 0,
            child: _buildHotspot('Abdomen'),
          ),
          Positioned(
            top: 200,
            left: 80,
            child: _buildHotspot('Left Limbs'),
          ),
          Positioned(
            top: 200,
            right: 80,
            child: _buildHotspot('Right Limbs'),
          ),
          Positioned(
            top: 270,
            left: 0,
            right: 0,
            child: _buildHotspot('Tail & Back'),
          ),
        ],
        
        // Control buttons
        if (!_isLoading && !_modelError)
          Positioned(
            top: 20,
            right: 20,
            child: Column(
              children: [
                // Rotate button
                _buildControlButton(
                  _isAutoRotating ? Icons.sync_disabled : Icons.sync,
                  _toggleAutoRotate,
                  'Auto-rotate',
                ),
                
                const SizedBox(height: 16),
                
                // Zoom in button
                _buildControlButton(
                  Icons.zoom_in,
                  () {
                    setState(() {
                      _zoomLevel = (_zoomLevel + 0.1).clamp(0.5, 2.0);
                    });
                  },
                  'Zoom in',
                ),
                
                const SizedBox(height: 16),
                
                // Zoom out button
                _buildControlButton(
                  Icons.zoom_out,
                  () {
                    setState(() {
                      _zoomLevel = (_zoomLevel - 0.1).clamp(0.5, 2.0);
                    });
                  },
                  'Zoom out',
                ),
              ],
            ),
          ),
      ],
    );
  }
  
  Widget _buildControlButton(IconData icon, VoidCallback onPressed, String tooltip) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: widget.isDark ? Colors.grey[850] : Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Tooltip(
        message: tooltip,
        child: IconButton(
          icon: Icon(icon, size: 20, color: AppColors.orange),
          onPressed: onPressed,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
  
  Widget _buildHotspot(String bodyPart) {
    return Center(
      child: GestureDetector(
        onTap: () => widget.onBodyPartSelected(bodyPart),
        child: Container(
          width: bodyPart == 'Head' ? 60 : 
               bodyPart.contains('Limbs') ? 40 : 
               bodyPart == 'Tail & Back' ? 50 : 80,
          height: bodyPart == 'Head' ? 60 : 
                bodyPart.contains('Limbs') ? 100 : 
                bodyPart == 'Tail & Back' ? 50 : 70,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(bodyPart == 'Head' ? 30 : 20),
            border: Border.all(color: AppColors.orange.withOpacity(0.5), width: 2),
          ),
        ),
      ),
    );
  }
  
  // Helper function to convert degrees to radians
  double _getRadians(double degrees) {
    return degrees * (3.141592653589793 / 180);
  }
}