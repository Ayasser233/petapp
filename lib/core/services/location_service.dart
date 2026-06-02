import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_colors.dart';
import 'package:flutter/material.dart';

class LocationService extends GetxService {
  static LocationService get instance => Get.find();

  // Observable properties
  final RxBool _isLocationEnabled = false.obs;
  final RxBool _isPermissionGranted = false.obs;
  final RxBool _isLoading = false.obs;
  final Rx<Position?> _currentPosition = Rx<Position?>(null);
  final RxString _currentAddress = ''.obs;
  final RxString _currentCity = ''.obs;
  final RxString _currentState = ''.obs;
  final RxString _currentCountry = ''.obs;
  final RxBool _isFirstLaunch = true.obs;

  // Getters
  bool get isLocationEnabled => _isLocationEnabled.value;
  bool get isPermissionGranted => _isPermissionGranted.value;
  bool get isLoading => _isLoading.value;
  Position? get currentPosition => _currentPosition.value;
  String get currentAddress => _currentAddress.value;
  String get currentCity => _currentCity.value;
  String get currentState => _currentState.value;
  String get currentCountry => _currentCountry.value;
  bool get isFirstLaunch => _isFirstLaunch.value;

  // Reactive getters for use in Obx widgets
  RxBool get isLocationEnabledRx => _isLocationEnabled;
  RxBool get isPermissionGrantedRx => _isPermissionGranted;
  RxBool get isLoadingRx => _isLoading;
  Rx<Position?> get currentPositionRx => _currentPosition;
  RxString get currentAddressRx => _currentAddress;
  RxString get currentCityRx => _currentCity;
  RxString get currentStateRx => _currentState;
  RxString get currentCountryRx => _currentCountry;
  RxBool get isFirstLaunchRx => _isFirstLaunch;

  // Location update stream
  StreamSubscription<Position>? _positionStream;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _checkFirstLaunch();
    await _initializeLocationService();
  }

  @override
  void onClose() {
    _positionStream?.cancel();
    super.onClose();
  }

  /// Check if this is first app launch
  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstLaunch.value = !(prefs.getBool('location_permission_requested') ?? false);
  }

  /// Mark location permission as requested
  Future<void> _markLocationPermissionRequested() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('location_permission_requested', true);
    _isFirstLaunch.value = false;
  }

  /// Initialize location service
  Future<void> _initializeLocationService() async {
    try {
      _isLoading.value = true;
      
      // Check if location service is enabled
      final isEnabled = await Geolocator.isLocationServiceEnabled();
      _isLocationEnabled.value = isEnabled;
      
      if (!isEnabled) {
        throw Exception('Location services are disabled.');
      }

      // Check permission status
      await _checkPermissionStatus();
      
      // Get current location if permission is granted
      if (_isPermissionGranted.value) {
        await getCurrentLocation();
        _startLocationUpdates();
      }
    } catch (e) {
      throw Exception('Error initializing location service: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Check current permission status
  Future<void> _checkPermissionStatus() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      _isPermissionGranted.value = permission == LocationPermission.whileInUse || 
                                   permission == LocationPermission.always;
    } catch (e) {
      throw Exception('Error checking permission status: $e');
    }
  }

  /// Request location permission
  Future<bool> requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.deniedForever) {
        _isPermissionGranted.value = false;
        _showOpenSettingsDialog();
        return false;
      }
      
      final isGranted = permission == LocationPermission.whileInUse || 
                       permission == LocationPermission.always;
      
      _isPermissionGranted.value = isGranted;
      
      // Mark as requested
      await _markLocationPermissionRequested();
      
      if (isGranted) {
        await getCurrentLocation();
        _startLocationUpdates();
      }
      
      return isGranted;
    } catch (e) {
      throw Exception('Error requesting permission: $e');
    }
  }

  /// Get current location
  Future<Position?> getCurrentLocation() async {
    try {
      if (!_isPermissionGranted.value) {
        throw Exception('Location permission not granted');
      }

      _isLoading.value = true;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      _currentPosition.value = position;
      
      // Get address from coordinates
      await _getAddressFromCoordinates(position.latitude, position.longitude);
      
      // Save last known location
      await _saveLastKnownLocation(position);
      
      return position;
    } catch (e) {
      // Try to load last known location
      await _loadLastKnownLocation();
      throw Exception('Error getting current location: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Start location updates
  void _startLocationUpdates() {
    if (!_isPermissionGranted.value) return;

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100, // Update every 100 meters
    );

    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) {
        _currentPosition.value = position;
        _getAddressFromCoordinates(position.latitude, position.longitude);
        _saveLastKnownLocation(position);
      },
      onError: (error) {
        throw Exception('Location stream error: $error');
      },
    );
  }

  /// Save last known location
  Future<void> _saveLastKnownLocation(Position position) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('last_latitude', position.latitude);
      await prefs.setDouble('last_longitude', position.longitude);
      await prefs.setInt('last_location_timestamp', DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      throw Exception('Error saving last known location: $e');
    }
  }

  /// Load last known location
  Future<void> _loadLastKnownLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final latitude = prefs.getDouble('last_latitude');
      final longitude = prefs.getDouble('last_longitude');
      final timestamp = prefs.getInt('last_location_timestamp');
      
      if (latitude != null && longitude != null && timestamp != null) {
        // Check if location is not too old (24 hours)
        final locationTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final now = DateTime.now();
        
        if (now.difference(locationTime).inHours < 24) {
          _currentPosition.value = Position(
            latitude: latitude,
            longitude: longitude,
            timestamp: locationTime,
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0,
            altitudeAccuracy: 0,
            headingAccuracy: 0,
          );
          
          await _getAddressFromCoordinates(latitude, longitude);
        }
      }
    } catch (e) {
      throw Exception('Error loading last known location: $e');
    }
  }

  /// Get address from coordinates
  Future<void> _getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        
        // Build full address
        final addressComponents = [
          placemark.street,
          placemark.subLocality,
          placemark.locality,
          placemark.administrativeArea,
          placemark.country,
        ].where((component) => component != null && component.isNotEmpty);
        
        _currentAddress.value = addressComponents.join(', ');
        _currentCity.value = placemark.locality ?? placemark.administrativeArea ?? 'Unknown';
        _currentState.value = placemark.administrativeArea ?? '';
        _currentCountry.value = placemark.country ?? '';
      }
    } catch (e) {
      _currentCity.value = 'Location found';
      throw Exception('Error getting address: $e');
    }
  }

  /// Calculate distance between two coordinates
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  /// Format distance for display
  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()}m';
    } else {
      final distanceInKm = distanceInMeters / 1000;
      if (distanceInKm < 10) {
        return '${distanceInKm.toStringAsFixed(1)}km';
      } else {
        return '${distanceInKm.round()}km';
      }
    }
  }

  /// Get location accuracy description
  String getLocationAccuracy() {
    final position = _currentPosition.value;
    if (position == null) return 'No location';
    
    final accuracy = position.accuracy;
    if (accuracy < 5) return 'Excellent';
    if (accuracy < 20) return 'Good';
    if (accuracy < 100) return 'Fair';
    return 'Poor';
  }

  /// Check if location is recent
  bool isLocationRecent() {
    final position = _currentPosition.value;
    if (position == null) return false;
    
    final now = DateTime.now();
    final locationTime = position.timestamp;
    return now.difference(locationTime).inMinutes < 30;
  }

  /// Show first time location permission dialog
  Future<bool> showFirstTimeLocationDialog() async {
    if (!_isFirstLaunch.value) return false;

    await Get.dialog<void>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.orange.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on,
                color: AppColors.orange,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Find Nearby Clinics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Allow Aleefy to access your location to:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.search, color: AppColors.orange, size: 20),
                SizedBox(width: 8),
                Expanded(child: Text('Find veterinary clinics nearby')),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.navigation, color: AppColors.orange, size: 20),
                SizedBox(width: 8),
                Expanded(child: Text('Get accurate distances and directions')),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.local_offer, color: AppColors.orange, size: 20),
                SizedBox(width: 8),
                Expanded(child: Text('Receive location-based offers')),
              ],
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Continue',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    return true;
  }

  /// Show settings dialog when permission is denied forever
  void _showOpenSettingsDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Location Permission Required'),
        content: const Text(
          'Location access has been permanently denied. Please enable it in your device settings to find nearby clinics.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await Geolocator.openAppSettings();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.orange),
            child: const Text('Open Settings', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Refresh location
  Future<void> refreshLocation() async {
    if (!_isPermissionGranted.value) {
      final granted = await requestLocationPermission();
      if (!granted) return;
    }
    await getCurrentLocation();
  }

  /// Show location disabled snackbar
  void showLocationDisabledMessage() {
    Get.snackbar(
      'Location Disabled',
      'Enable location to find nearby clinics',
      icon: const Icon(Icons.location_off, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      mainButton: TextButton(
        onPressed: () => requestLocationPermission(),
        child: const Text('Enable', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  /// Get distance to clinic
  String getDistanceToClinic(double clinicLat, double clinicLon) {
    final currentPos = _currentPosition.value;
    if (currentPos == null) return 'Unknown';
    
    final distance = calculateDistance(
      currentPos.latitude,
      currentPos.longitude,
      clinicLat,
      clinicLon,
    );
    
    return formatDistance(distance);
  }

  /// Check if clinic is within range
  bool isClinicInRange(double clinicLat, double clinicLon, double maxDistanceKm) {
    final currentPos = _currentPosition.value;
    if (currentPos == null) return true; // Show all if no location
    
    final distance = calculateDistance(
      currentPos.latitude,
      currentPos.longitude,
      clinicLat,
      clinicLon,
    );
    
    return distance / 1000 <= maxDistanceKm;
  }
}
