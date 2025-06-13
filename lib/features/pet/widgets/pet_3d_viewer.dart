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
              cameraControls: widget.allowRotation,
              disableZoom: !widget.allowZoom,
              disableTap: true,
              interpolationDecay: 200,
              fieldOfView: '25deg',
              minFieldOfView: '25deg',
              maxFieldOfView: '30deg',
              minCameraOrbit: '${_rotationAngle}deg 60deg auto',
              maxCameraOrbit: '${_rotationAngle + 360}deg 120deg auto',
              cameraOrbit: '${_rotationAngle}deg 75deg auto',
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
              
            // Rotate button positioned inside the model viewer (top right corner)
            if (!_isLoading)
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.orange,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _rotateModel,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: const Icon(
                          Icons.rotate_right,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
            
          ],
        ),
      ),
    );
  }

  // Method to rotate the model by 90 degrees
  void _rotateModel() {
    setState(() {
      _rotationAngle = (_rotationAngle + 90) % 360;
      // Create a completely new key to force full rebuild
      _modelViewerKey = GlobalKey();
    });
  }

}