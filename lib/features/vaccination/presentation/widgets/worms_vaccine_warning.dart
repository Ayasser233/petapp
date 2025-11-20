import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/app_colors.dart';
import '../../utils/vaccination_utils.dart';

/// Worming Vaccine Warning Widget
///
/// Displays warnings for worming vaccine protocol violations:
/// - Too early: Before Day 14 from first dose
/// - Too late: After Day 20 from first dose
///
/// Protocol:
/// - 1st dose: Day 0
/// - 2nd dose: MUST be given between Day 14-20
/// - Before Day 14: Too early, invalid
/// - After Day 20: Too late, must restart
class WormsVaccineWarning extends StatelessWidget {
  final String vaccineType;
  final int doseNumber;
  final DateTime? firstDoseDate;
  final VoidCallback? onRestartVaccination;

  const WormsVaccineWarning({
    Key? key,
    required this.vaccineType,
    required this.doseNumber,
    this.firstDoseDate,
    this.onRestartVaccination,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Only show for worms vaccines, 2nd dose
    if (!VaccinationUtils.isWormsVaccine(vaccineType)) {
      return const SizedBox.shrink();
    }

    if (doseNumber != 2) {
      return const SizedBox.shrink();
    }

    if (firstDoseDate == null) {
      return const SizedBox.shrink();
    }

    // Check if too early
    final isTooEarly = VaccinationUtils.isWormsDoseTooEarly(
      vaccineType,
      doseNumber,
      firstDoseDate,
    );

    // Check if expired
    final isExpired = VaccinationUtils.isWormsWindowExpired(
      vaccineType,
      doseNumber,
      firstDoseDate,
    );

    // Only show if too early or expired
    if (!isTooEarly && !isExpired) {
      return const SizedBox.shrink();
    }

    if (isTooEarly) {
      return _buildTooEarlyWarning(context);
    } else {
      return _buildExpiredWarning(context);
    }
  }

  Widget _buildTooEarlyWarning(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final firstDoseDateFormatted = DateFormat('MMM dd, yyyy').format(firstDoseDate!);
    final windowOpenDate = VaccinationUtils.getWormsWindowOpenDate(firstDoseDate);
    final windowOpenDateFormatted = windowOpenDate != null
        ? DateFormat('MMM dd, yyyy').format(windowOpenDate)
        : '';

    final daysUntil = VaccinationUtils.getDaysUntilWormsWindowOpens(
      vaccineType,
      doseNumber,
      firstDoseDate,
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Warning Icon and Title
          Row(
            children: [
              const Icon(
                Icons.schedule,
                color: Colors.orange,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  localizations.warningTooEarlyFor2ndDose,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Warning Message
          Text(
            localizations.waitMoreDaysBeforeSecondDose(daysUntil ?? 0),
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Timeline Information
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTimelineItem(
                  context,
                  localizations.firstDose,
                  firstDoseDateFormatted,
                  Colors.green,
                  Icons.check_circle,
                ),
                const SizedBox(height: 8),
                _buildTimelineItem(
                  context,
                  localizations.windowOpensDay14,
                  windowOpenDateFormatted,
                  Colors.orange,
                  Icons.lock_clock,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Protocol Information
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.wormingVaccineProtocol,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                _buildProtocolItem(context, localizations.dosesRequired2),
                _buildProtocolItem(context, localizations.secondDoseDay14to20Only),
                _buildProtocolItem(context, localizations.beforeDay14TooEarly),
                _buildProtocolItem(context, localizations.afterDay20MustRestart),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiredWarning(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final firstDoseDateFormatted = DateFormat('MMM dd, yyyy').format(firstDoseDate!);
    final latestValidDate = VaccinationUtils.getWormsWindowCloseDate(firstDoseDate);
    final latestValidDateFormatted = latestValidDate != null
        ? DateFormat('MMM dd, yyyy').format(latestValidDate)
        : '';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Warning Icon and Title
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  localizations.warning2ndDoseWindowExpired,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Warning Message
          Text(
            localizations.wormsSecondDoseExpired,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Timeline Information
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTimelineItem(
                  context,
                  localizations.firstDose,
                  firstDoseDateFormatted,
                  Colors.green,
                  Icons.check_circle,
                ),
                const SizedBox(height: 8),
                _buildTimelineItem(
                  context,
                  localizations.windowClosedDay20,
                  latestValidDateFormatted,
                  Colors.red,
                  Icons.cancel,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Protocol Information
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.wormingVaccineProtocol,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                _buildProtocolItem(context, localizations.doses2Between14to20Days),
                _buildProtocolItem(context, localizations.validWindowDay14to20),
                _buildProtocolItem(context, localizations.afterDay20MustRestartFromBeginning),
              ],
            ),
          ),

          // Action Button
          if (onRestartVaccination != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onRestartVaccination,
                icon: const Icon(Icons.replay),
                label: Text(localizations.restartVaccinationSeries),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    String label,
    String date,
    Color color,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              if (date.isNotEmpty)
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProtocolItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 14)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

/// Worming Vaccine Info Card
///
/// Shows information about the worming vaccine window
/// Only displays when within valid window (Day 14-20)
class WormsVaccineInfoCard extends StatelessWidget {
  final String vaccineType;
  final int doseNumber;
  final DateTime? firstDoseDate;

  const WormsVaccineInfoCard({
    Key? key,
    required this.vaccineType,
    required this.doseNumber,
    this.firstDoseDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Only show for worms vaccines, 2nd dose
    if (!VaccinationUtils.isWormsVaccine(vaccineType)) {
      return const SizedBox.shrink();
    }

    if (doseNumber != 2) {
      return const SizedBox.shrink();
    }

    if (firstDoseDate == null) {
      return const SizedBox.shrink();
    }

    // Check if within valid window
    final isValid = VaccinationUtils.isWormsSecondDoseValid(
      vaccineType,
      doseNumber,
      firstDoseDate,
    );

    // Only show if within valid window
    if (isValid != true) {
      return const SizedBox.shrink();
    }

    final daysRemaining = VaccinationUtils.getWormsWindowDaysRemaining(
      vaccineType,
      doseNumber,
      firstDoseDate,
    );

    if (daysRemaining == null) {
      return const SizedBox.shrink();
    }

    final windowOpenDate = VaccinationUtils.getWormsWindowOpenDate(firstDoseDate);
    final windowCloseDate = VaccinationUtils.getWormsWindowCloseDate(firstDoseDate);
    final localizations = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.orange,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.orange,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  localizations.wormingVaccineInfo,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.orange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Days Remaining
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.daysRemaining,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '$daysRemaining ${localizations.locale.languageCode == 'ar' ? "يوم" : "day${daysRemaining == 1 ? '' : 's'}"}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: daysRemaining <= 3 ? Colors.red : AppColors.orange,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Dates
          if (windowOpenDate != null && windowCloseDate != null) ...[
            _buildDateRow(
              context,
              localizations.windowOpensDay14,
              DateFormat('MMM dd, yyyy').format(windowOpenDate),
              Colors.green,
            ),
            const SizedBox(height: 8),
            _buildDateRow(
              context,
              localizations.windowClosedDay20,
              DateFormat('MMM dd, yyyy').format(windowCloseDate),
              Colors.red,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateRow(BuildContext context, String label, String date, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        Text(
          date,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

