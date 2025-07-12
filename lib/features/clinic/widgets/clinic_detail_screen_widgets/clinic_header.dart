import 'package:flutter/material.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:url_launcher/url_launcher.dart';

class ClinicHeader extends StatefulWidget {
  final Map<String, dynamic> clinic;

  const ClinicHeader({
    super.key,
    required this.clinic,
  });

  @override
  State<ClinicHeader> createState() => _ClinicHeaderState();
}

class _ClinicHeaderState extends State<ClinicHeader> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Clinic Image
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            widget.clinic['image'] ?? 'assets/images/pet_hospital.jpg',
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[300],
                child: const Icon(
                  Icons.local_hospital,
                  size: 50,
                  color: Colors.grey,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        
        // Clinic Name and Favorite Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.clinic['name'] ?? 'BluePearl Pet Hospital',
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
                    widget.clinic['location'] ?? 'Healdsburg, CA',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.orange,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '• ${widget.clinic['distance'] ?? '11 ${AppLocalizations.of(context).minutes}'}',
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
    // Get coordinates from clinic data
    final double? latitude = widget.clinic['latitude']?.toDouble();
    final double? longitude = widget.clinic['longitude']?.toDouble();
    final String? mapUrl = widget.clinic['mapUrl']; // Direct link option
    
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
      final String location = widget.clinic['location'] ?? 'Healdsburg, CA';
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