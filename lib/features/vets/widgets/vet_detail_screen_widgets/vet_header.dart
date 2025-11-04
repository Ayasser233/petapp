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
    // Get images from vet data or use default images
    final images = widget.vet['images'];

    // Debug: Print to see what images we're getting
    print('🔍 VetHeader - Images from vet data: $images');
    print('🔍 VetHeader - Images type: ${images.runtimeType}');

    if (images != null && images is List && images.isNotEmpty) {
      return List<String>.from(images);
    }

    // Check for single image field
    if (widget.vet['image'] != null &&
        widget.vet['image'].toString().isNotEmpty) {
      return [widget.vet['image'].toString()];
    }

    // Default fallback images
    return [
      'assets/images/pet_hospital.jpg',
      'assets/images/pet_hospital2.jpg',
      'assets/images/pet_hospital3.jpg',
    ];
  }

  Widget _buildImage(String imagePath) {
    // Check if it's a network URL or local asset
    final isNetworkImage = imagePath.startsWith('http://') ||
        imagePath.startsWith('https://') ||
        imagePath.startsWith('www.');

    print('🔍 VetHeader - Image path: $imagePath, isNetwork: $isNetworkImage');

    if (isNetworkImage) {
      // Load network image
      return Image.network(
        imagePath,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
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
          print('❌ Error loading network image: $error');
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
          print('❌ Error loading asset image: $error');
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Photo Slider
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 250,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: vetImages.length,
                  itemBuilder: (context, index) {
                    return _buildImage(vetImages[index]);
                  },
                ),
              ),
            ),
            // Page Indicator
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
            // Navigation Arrows
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
                      child: const Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                      ),
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
                      child: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
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
            // Image Counter
            if (vetImages.length > 1)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
          ],
        ),
        const SizedBox(height: 16),

        // Vet Name and Favorite Button
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
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
            ),
          ],
        ),

        // Interactive Location
        GestureDetector(
          onTap: () => _openGoogleMaps(),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: AppColors.orange,
                  size: 16,
                ),
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
                Text(
                  '• ${widget.vet['distance'] ?? '11 ${AppLocalizations.of(context).minutes}'}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: subTextColor,
                      ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.open_in_new,
                  color: AppColors.orange,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Open Google Maps - Best Practice Implementation
  Future<void> _openGoogleMaps() async {
    // Get coordinates from vet data
    final double? latitude = widget.vet['latitude']?.toDouble();
    final double? longitude = widget.vet['longitude']?.toDouble();
    final String? mapUrl = widget.vet['mapUrl']; // Direct link option

    try {
      // Option 1: Use direct map URL if provided
      if (mapUrl != null && mapUrl.isNotEmpty) {
        await _launchUrl(mapUrl);
        return;
      }

      // Option 2: Use coordinates if available
      if (latitude != null && longitude != null) {
        await _launchWithCoordinates(latitude, longitude);
        return;
      }

      // Option 3: Fallback to location name
      final String location = widget.vet['location'] ?? 'Healdsburg, CA';
      await _launchWithLocationName(location);
    } catch (e) {
      _showErrorMessage();
    }
  }

  /// Launch with coordinates (most accurate)
  Future<void> _launchWithCoordinates(double latitude, double longitude) async {
    final urls = [
      // Google Maps app (Android)
      'geo:$latitude,$longitude?q=$latitude,$longitude',
      // Google Maps web
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
      // Apple Maps (iOS)
      'http://maps.apple.com/?ll=$latitude,$longitude',
    ];

    for (String url in urls) {
      if (await _launchUrl(url)) {
        return;
      }
    }

    throw Exception('Could not launch any map URL');
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
