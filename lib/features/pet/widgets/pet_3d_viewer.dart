import 'package:flutter/material.dart';
import 'package:petapp/features/pet/widgets/pet_3d_viewer_webview.dart';

// Export the mapper so it can be used elsewhere
export 'package:petapp/features/pet/widgets/pet_3d_viewer_webview.dart'
    show MeshBodyPartMapper;

/// Pet 3D Viewer - now uses WebView for full GLB support and mesh interaction
/// This is a wrapper widget that provides the same API as before but uses
/// the WebView implementation for better GLB support
class Pet3DViewer extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Pet3DViewerWebView(
      petType: petType,
      modelPath: modelPath,
      allowRotation: allowRotation,
      allowZoom: allowZoom,
      viewerHeight: viewerHeight,
      backgroundColor: backgroundColor,
      onMeshClicked: onSymptomSelected,
    );
  }
}
