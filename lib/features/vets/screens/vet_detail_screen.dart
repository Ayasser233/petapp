import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import '../widgets/vet_detail_screen_widgets/vet_header.dart';
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

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() {
      _isLoadingReviews = true;
    });

    try {
      final vetId = widget.vet['id']?.toString();
      if (vetId != null && vetId.isNotEmpty) {
        final response = await _vetService.getVetReviews(vetId, limit: 20);
        setState(() {
          _reviews = response.reviews;
          _isLoadingReviews = false;
        });
      } else {
        setState(() {
          _isLoadingReviews = false;
        });
      }
    } catch (e) {
      print('Error loading reviews: $e');
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
    final consultationFee = widget.vet['consultationFee'];
    final consultationPrice = consultationFee != null
        ? '${consultationFee.toString()} EGP'
        : '75.00 EGP';

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(context, isDark, textColor),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VetHeader(vet: widget.vet),
              const SizedBox(height: 24),
              VetStats(vet: widget.vet),
              const SizedBox(height: 24),
              VetDescription(vet: widget.vet),
              const SizedBox(height: 24),
              VetServices(
                services: (widget.vet['services'] as List<dynamic>?)
                        ?.map((e) => e.toString())
                        .toList() ??
                    [],
              ),
              const SizedBox(height: 24),
              VetConsultationFee(price: consultationPrice),
              const SizedBox(height: 24),
              // Reviews Section
              VetReviews(
                reviews: _reviews,
                isLoading: _isLoadingReviews,
              ),
              const SizedBox(height: 80), // Space for bottom button
            ],
          ),
        ),
      ),
      bottomNavigationBar: VetActionButton(
        vet: widget.vet,
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
        onPressed: () => Get.back(),
      ),
      title: Text(
        AppLocalizations.of(context).vetDetails,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert, color: textColor),
          onPressed: () {
            _showOptionsMenu(context);
          },
        ),
      ],
      centerTitle: true,
      elevation: 0,
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: Text(AppLocalizations.of(context).share),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: Text(AppLocalizations.of(context).report),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
