import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import '../widgets/clinic_detail_screen_widgets/clinic_header.dart';
import '../widgets/clinic_detail_screen_widgets/clinic_stats.dart';
import '../widgets/clinic_detail_screen_widgets/clinic_description.dart';
import '../widgets/clinic_detail_screen_widgets/clinic_services.dart';
import '../widgets/clinic_detail_screen_widgets/clinic_consultation_fee.dart';
import '../widgets/clinic_detail_screen_widgets/clinic_working_hours.dart';
import '../widgets/clinic_detail_screen_widgets/clinic_action_button.dart';

class ClinicDetailScreen extends StatelessWidget {
  final Map<String, dynamic> clinic;
  
  const ClinicDetailScreen({
    super.key,
    required this.clinic,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final backgroundColor = isDark ? Colors.black : Colors.white;
    const consultationPrice = '\$75.00';

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(context, isDark, textColor),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClinicHeader(clinic: clinic),
              const SizedBox(height: 24),
              ClinicStats(clinic: clinic),
              const SizedBox(height: 24),
              ClinicDescription(clinic: clinic),
              const SizedBox(height: 24),
              const ClinicServices(),
              const SizedBox(height: 24),
              const ClinicConsultationFee(price: consultationPrice),
              const SizedBox(height: 24),
              const ClinicWorkingHours(),
              const SizedBox(height: 80), // Space for bottom button
            ],
          ),
        ),
      ),
      bottomNavigationBar: ClinicActionButton(
        clinic: clinic,
        price: consultationPrice,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark, Color textColor) {
    return AppBar(
      backgroundColor: isDark ? Colors.black : Colors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: textColor),
        onPressed: () => Get.back(),
      ),
      title: Text(
        AppLocalizations.of(context).clinicDetails,
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