import 'package:flutter/material.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:url_launcher/url_launcher.dart';

class VetHeader extends StatefulWidget {
  final Map<String, dynamic> vet;

  const VetHeader({
    super.key,
    required this.vet,
  });

  @override
  State<VetHeader> createState() => _ClinicHeaderState();
}

class _ClinicHeaderState extends State<VetHeader> {
  bool isFavorite = false;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<String> _getVetImages() {
    // Gallery images only (vets/... paths)
    final images = widget.vet['images'];
    List<String> vetImages = [];

    if (images != null && images is List && images.isNotEmpty) {
      vetImages = images
          .where((img) => img != null && img.toString().trim().isNotEmpty)
          .map((img) => _convertImagePath(img.toString()))
          .toList();
    }

    if (vetImages.isNotEmpty) return vetImages;

    // Fallback to any single image field
    final singleImage = widget.vet['image']?.toString() ??
        widget.vet['imageUrl']?.toString() ??
        widget.vet['photo']?.toString();
    if (singleImage != null && singleImage.trim().isNotEmpty) {
      return [_convertImagePath(singleImage)];
    }

    return [
      'assets/images/pet_hospital.jpg',
    ];
  }

  /// Returns the profile/avatar image URL (separate from gallery)
  String? _getProfileImage() {
    final raw = widget.vet['profileImage']?.toString().trim();
    if (raw != null && raw.isNotEmpty) return _convertImagePath(raw);
    return null;
  }

  /// Convert image path to full URL - matches VetModel logic
  String _convertImagePath(String imagePath) {
    // If already a full URL or asset path, return as is
    if (imagePath.startsWith('http://') ||
        imagePath.startsWith('https://') ||
        imagePath.startsWith('assets/')) {
      return imagePath;
    }

    // For paths like "users/abc.jpg" or "vets/abc.jpg"
    // Images are served from MinIO storage
    const minioBaseUrl = 'https://minio-api.aleefy-app.com/uploads';
    String cleanPath = imagePath;

    // Remove "uploads/" prefix if present (since we'll add it back)
    if (cleanPath.startsWith('uploads/')) {
      cleanPath = cleanPath.replaceFirst('uploads/', '');
    }

    // Build the URL with MinIO base URL
    return '$minioBaseUrl/$cleanPath';
  }

  Widget _buildImage(String imagePath) {
    // Check if it's a network URL or local asset
    final isNetworkImage = imagePath.startsWith('http://') ||
        imagePath.startsWith('https://') ||
        imagePath.startsWith('www.');


    if (isNetworkImage) {
      return Image.network(
        imagePath,
        width: double.infinity,
        fit: BoxFit.cover,
        // Add cache control headers
        headers: const {
          'Cache-Control': 'no-cache, no-store, must-revalidate',
          'Pragma': 'no-cache',
          'Expires': '0',
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Container(
            width: double.infinity,
            color: Colors.grey[300],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: AppColors.orange,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            color: Colors.grey[300],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.local_hospital,
                  size: 50,
                  color: Colors.grey,
                ),
                const SizedBox(height: 8),
                Text(
                  'Image not available',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        },
      );
    } else {
      // Load local asset image
      return Image.asset(
        imagePath,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            color: Colors.grey[300],
            child: const Icon(
              Icons.local_hospital,
              size: 50,
              color: Colors.grey,
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];
    final vetImages = _getVetImages();
    final profileImageUrl = _getProfileImage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Gallery slider + profile avatar overlay ──────────────
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Gallery slider
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 220,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemCount: vetImages.length,
                  itemBuilder: (context, index) => _buildImage(vetImages[index]),
                ),
              ),
            ),
            // Page indicator dots
            if (vetImages.length > 1)
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    vetImages.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? AppColors.orange
                            : Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            // Navigation arrows
            if (vetImages.length > 1) ...[
              Positioned(
                left: 8,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.chevron_left, color: Colors.white),
                    ),
                    onPressed: () {
                      if (_currentPage > 0) {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ),
              ),
              Positioned(
                right: 8,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.chevron_right, color: Colors.white),
                    ),
                    onPressed: () {
                      if (_currentPage < vetImages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
            // Image counter
            if (vetImages.length > 1)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentPage + 1}/${vetImages.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            // ── Profile avatar (bottom-left, overlapping gallery) ──
            if (profileImageUrl != null)
              Positioned(
                bottom: -28,
                left: 16,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? Colors.grey[900]! : Colors.white,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: NetworkImage(profileImageUrl),
                    onBackgroundImageError: (_, __) {},
                  ),
                ),
              ),
          ],
        ),

        // Space to account for avatar overflow
        SizedBox(height: profileImageUrl != null ? 44 : 16),

        // ── Name and Favorite Button ────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.vet['name'] ?? 'BluePearl Pet Vet',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
              ),
            ),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: AppColors.orange,
              ),
              onPressed: () => setState(() => isFavorite = !isFavorite),
            ),
          ],
        ),

        // ── Interactive Location ────────────────────────────────
        GestureDetector(
          onTap: () => _openGoogleMaps(),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: AppColors.orange, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.vet['location'] ?? 'Healdsburg, CA',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.orange,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                ),
                const SizedBox(width: 4),
                Builder(builder: (context) {
                  final dist = widget.vet['distance']?.toString() ?? '';
                  final show = dist.isNotEmpty &&
                      dist != 'Calculating...' &&
                      dist != 'null';
                  if (!show) return const SizedBox.shrink();
                  return Text(
                    '• $dist',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: subTextColor,
                        ),
                  );
                }),
                const SizedBox(width: 4),
                const Icon(Icons.open_in_new, color: AppColors.orange, size: 14),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Open Google Maps - Best Practice Implementation
  Future<void> _openGoogleMaps() async {
    final String? mapUrl = widget.vet['mapUrl']?.toString();

    try {
      if (mapUrl != null && mapUrl.trim().isNotEmpty) {
        await _launchUrl(mapUrl.trim());
        return;
      }

      // Fallback: location name/address search (no coordinates)
      final String location = widget.vet['location'] ?? 'Healdsburg, CA';
      await _launchWithLocationName(location);
    } catch (e) {
      _showErrorMessage();
    }
  }

  /// Launch with location name
  Future<void> _launchWithLocationName(String location) async {
    final encodedLocation = Uri.encodeComponent(location);
    final urls = [
      // Google Maps web
      'https://www.google.com/maps/search/?api=1&query=$encodedLocation',
      // Apple Maps
      'http://maps.apple.com/?q=$encodedLocation',
    ];

    for (String url in urls) {
      if (await _launchUrl(url)) {
        return;
      }
    }

    throw Exception('Could not launch any map URL');
  }

  /// Launch URL helper
  Future<bool> _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      }
    } catch (e) {
      // Continue to next URL
    }
    return false;
  }

  /// Show error message
  void _showErrorMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).cannotOpenMaps),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: AppLocalizations.of(context).ok,
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}
