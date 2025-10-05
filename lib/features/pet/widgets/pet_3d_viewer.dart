import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:petapp/core/utils/helper_functions.dart';
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

class _Pet3DViewerState extends State<Pet3DViewer> {
  bool _isLoading = true;
  GlobalKey _modelViewerKey = GlobalKey();
  int _rotationAngle = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final backgroundColor = widget.backgroundColor ?? 
        (isDark ? Colors.black : Colors.grey[100]);

    // Determine which model to use
    final String modelSrc = widget.modelPath ?? 
        (widget.petType.toLowerCase() == 'dog'
            ? 'assets/models/dog_model.glb'
            : 'assets/models/cat_model.glb');

    return Container(
      height: widget.viewerHeight,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // The model viewer widget
            ModelViewer(
              key: _modelViewerKey,
              backgroundColor: backgroundColor!,
              src: modelSrc,
              alt: '3D Model of ${widget.petType}',
              ar: false,
              autoRotate: false,
              cameraControls: false, // Disable free movement
              disableZoom: true, // Disable zoom for fixed view
              disableTap: true,
              interpolationDecay: 200,
              fieldOfView: '30deg',
              minFieldOfView: '30deg',
              maxFieldOfView: '30deg',
              // Fixed camera position with only controlled rotation
              cameraOrbit: '${_rotationAngle}deg 75deg 2.5m',
              minCameraOrbit: '${_rotationAngle}deg 75deg 2.5m',
              maxCameraOrbit: '${_rotationAngle}deg 75deg 2.5m',
              shadowIntensity: 0,
              exposure: 1.0,
              loading: Loading.eager,
              onWebViewCreated: (controller) {
                // Model is ready when web view is created
                Future.delayed(const Duration(milliseconds: 1500), () {
                  if (mounted && _isLoading) {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                });
              },
            ),
            // Loading indicator
            if (_isLoading)
              Container(
                color: backgroundColor,
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
              
            // Control buttons positioned inside the model viewer (top right corner)
            if (!_isLoading)
              Positioned(
                top: 16,
                right: 16,
                child: Column(
                  children: [
                    // Rotate right button
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.orange,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: _rotateModel,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.rotate_right,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '90°',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Rotate left button
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.orange.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: _rotateModelLeft,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.rotate_left,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '90°',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Reset button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: _resetRotation,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // Rotation indicator (bottom center)
            if (!_isLoading)
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.rotate_90_degrees_ccw,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$_rotationAngle°',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
            
          ],
        ),
      ),
    );
  }

  // Method to rotate the model by 90 degrees clockwise
  void _rotateModel() {
    setState(() {
      // Rotate by exactly 90 degrees clockwise
      _rotationAngle = (_rotationAngle + 90) % 360;
      // Force rebuild to apply new camera position
      _modelViewerKey = GlobalKey();
    });
    
    // Optional: Add haptic feedback
    // HapticFeedback.lightImpact();
  }

  // Method to rotate the model by 90 degrees counter-clockwise
  void _rotateModelLeft() {
    setState(() {
      // Rotate by exactly 90 degrees counter-clockwise
      _rotationAngle = (_rotationAngle - 90) % 360;
      // Ensure positive angle
      if (_rotationAngle < 0) _rotationAngle += 360;
      // Force rebuild to apply new camera position
      _modelViewerKey = GlobalKey();
    });
    
    // Optional: Add haptic feedback
    // HapticFeedback.lightImpact();
  }

  // Method to reset rotation to original position
  void _resetRotation() {
    setState(() {
      _rotationAngle = 0;
      // Force rebuild to apply reset position
      _modelViewerKey = GlobalKey();
    });
  }

}