import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:petapp/core/services/location_service.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import '../widgets/vet_detail_screen_widgets/vet_header.dart';
import '../widgets/vet_detail_screen_widgets/vet_availability_status.dart';
import '../widgets/vet_detail_screen_widgets/vet_stats.dart';
import '../widgets/vet_detail_screen_widgets/vet_description.dart';
import '../widgets/vet_detail_screen_widgets/vet_services.dart';
import '../widgets/vet_detail_screen_widgets/vet_consultation_fee.dart';
import '../widgets/vet_detail_screen_widgets/vet_action_button.dart';
import '../widgets/vet_detail_screen_widgets/vet_reviews.dart';
import '../models/review_model.dart';
import '../services/vet_service.dart';

class VetDetailScreen extends StatefulWidget {
  final Map<String, dynamic> vet;

  const VetDetailScreen({
    super.key,
    required this.vet,
  });

  @override
  State<VetDetailScreen> createState() => _VetDetailScreenState();
}

class _VetDetailScreenState extends State<VetDetailScreen> {
  final VetService _vetService = VetService();
  List<ReviewModel> _reviews = [];
  bool _isLoadingReviews = false;
  int _totalReviews = 0;

  /// A copy of the vet map enriched with the real calculated distance.
  late Map<String, dynamic> _vet;

  @override
  void initState() {
    super.initState();
    _vet = Map<String, dynamic>.from(widget.vet);
    _loadReviews();
    _calcDistance();
  }

  /// Compute the distance between the user and this vet using lat/lng,
  /// then rebuild so the header shows it.
  Future<void> _calcDistance() async {
    try {
      final locationService = Get.find<LocationService>();
      if (!locationService.isPermissionGranted) return;
      final pos = locationService.currentPosition;
      if (pos == null) return;

      final vetLat = _parseDouble(_vet['latitude']);
      final vetLng = _parseDouble(_vet['longitude']);
      if (vetLat == null || vetLng == null) return;

      final meters = Geolocator.distanceBetween(
          pos.latitude, pos.longitude, vetLat, vetLng);

      final formatted = meters < 1000
          ? '${meters.round()} م'
          : '${(meters / 1000).toStringAsFixed(1)} كم';

      if (mounted) {
        setState(() {
          _vet = Map<String, dynamic>.from(_vet)..['distance'] = formatted;
        });
      }
    } catch (_) {
      // best effort
    }
  }

  static double? _parseDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  Future<void> _loadReviews() async {
    setState(() {
      _isLoadingReviews = true;
    });

    try {
      final vetId = widget.vet['id']?.toString();
      if (vetId != null && vetId.isNotEmpty) {
        final response = await _vetService.getVetReviews(vetId);
        setState(() {
          _reviews = response.reviews;
          _totalReviews = response.total;
          _isLoadingReviews = false;
        });
      } else {
        setState(() {
          _isLoadingReviews = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingReviews = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final backgroundColor = isDark ? Colors.black : Colors.white;

    // Get consultation fee from clinic data or use default
    final consultationFee = _vet['consultationFee'];
    final consultationPrice = consultationFee != null
        ? '${consultationFee.toString()} EGP'
        : '75.00 EGP';

    final emergencyPrice = _vet['emergencyPrice'] != null
        ? (_vet['emergencyPrice'] is int
            ? (_vet['emergencyPrice'] as int).toDouble()
            : _vet['emergencyPrice'] as double?)
        : null;
    final hasEmergency = _vet['hasEmergency'] == true;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(context, isDark, textColor),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VetHeader(vet: _vet),
              const SizedBox(height: 12),
              VetAvailabilityStatus(vet: _vet),
              const SizedBox(height: 24),
              VetStats(
                vet: _vet,
                totalReviews: _totalReviews,
              ),
              const SizedBox(height: 24),
              VetDescription(vet: _vet),
              const SizedBox(height: 24),
              VetServices(
                services: (_vet['services'] as List<dynamic>?)
                        ?.map((e) => e.toString())
                        .toList() ??
                    [],
              ),
              const SizedBox(height: 24),
              VetConsultationFee(
                price: consultationPrice,
                emergencyPrice: emergencyPrice,
                hasEmergency: hasEmergency,
              ),
              const SizedBox(height: 24),
              // Reviews Section
              VetReviews(
                reviews: _reviews,
                isLoading: _isLoadingReviews,
                totalReviews: _totalReviews,
                vetId: widget.vet['id']?.toString() ?? '',
                vetName: widget.vet['name']?.toString() ?? '',
              ),
              const SizedBox(height: 80), // Space for bottom button
            ],
          ),
        ),
      ),
      bottomNavigationBar: VetActionButton(
        vet: _vet,
        price: consultationPrice,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, bool isDark, Color textColor) {
    return AppBar(
      backgroundColor: isDark ? Colors.black : Colors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: textColor),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        AppLocalizations.of(context).vetDetails,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
      ),
     
      centerTitle: true,
      elevation: 0,
    );
  }

}
