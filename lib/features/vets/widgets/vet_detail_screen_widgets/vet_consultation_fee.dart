import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';

class VetConsultationFee extends StatelessWidget {
  final String price;
  final double? emergencyPrice;
  final bool hasEmergency;
  /// The final discounted price to display. If null, shows the [price] as is.
  final double? discountedPrice;
  final Map<String, dynamic>? vet;

  const VetConsultationFee({
    super.key,
    required this.price,
    this.emergencyPrice,
    this.hasEmergency = false,
    this.discountedPrice,
    this.vet,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];

    // Extract numeric value from price string
    final priceValue = price.replaceAll(RegExp(r'[^0-9.]'), '').trim();
    final originalFee = double.tryParse(priceValue) ?? 0;

    final isEmergencyTime = THelperFunctions.isEmergencyTime();
    final hasDiscount = discountedPrice != null && discountedPrice! < originalFee && !isEmergencyTime;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEmergencyTime 
          ? Colors.red.withValues(alpha: isDark ? 0.15 : 0.08)
          : AppColors.orange.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEmergencyTime ? Colors.red.withValues(alpha: 0.3) : AppColors.orange.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          // ── Consultation Fee Row ────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEmergencyTime 
                        ? AppLocalizations.of(context).emergencyFee
                        : AppLocalizations.of(context).consultationFee,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: isEmergencyTime ? Colors.red : textColor,
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isEmergencyTime
                        ? 'Active during emergency hours (10PM - 7AM)'
                        : AppLocalizations.of(context).initialExaminationFee,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: subTextColor,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (hasDiscount) ...[
                    Text(
                      price,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${discountedPrice!.toStringAsFixed(0)} EGP',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: const Color(0xFF2E7D32),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ] else
                    Text(
                      isEmergencyTime && discountedPrice != null
                        ? '${discountedPrice!.toStringAsFixed(0)} EGP'
                        : price,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: isEmergencyTime ? Colors.red : AppColors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                ],
              ),
            ],
          ),

          // (Removed "You save with Aleefy's exclusive discount" banner)

          // ── Emergency Fee Row ───────────────────────────────────
          if (hasEmergency && emergencyPrice != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: isDark ? 0.15 : 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.red.withValues(alpha: isDark ? 0.4 : 0.25),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.emergency, color: Colors.red, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).emergencyFee,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Text(
                    '${emergencyPrice!.toStringAsFixed(0)} EGP',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),
          // ── Points earning note ─────────────────────────────────
          Row(
            children: [
              const Icon(Icons.stars, color: Colors.green, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: subTextColor,
                          height: 1.3,
                        ),
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(context).earnPoints,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        // Points are based on the final price (which is the emergency fee during emergency time)
                        text: discountedPrice != null
                            ? discountedPrice!.toStringAsFixed(0)
                            : (priceValue.isNotEmpty ? priceValue : '75'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isEmergencyTime ? Colors.red : Colors.green,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: AppLocalizations.of(context).pointsAfterCompletion,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
